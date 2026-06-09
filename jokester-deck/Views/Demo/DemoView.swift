import SwiftUI
import SwiftData

struct DemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.languageManager) private var languageManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var games: [CardGame]
    @Query private var progressRows: [UserProgress]

    var game: CardGame?

    @AppStorage("demoGameSlug") private var selectedDemoSlug = ""
    @State private var viewModel = DemoViewModel()
    @State private var showStrategyTips = false

    private var progress: UserProgress? { progressRows.first }
    private var level: Int { progress?.level ?? 1 }

    private var unlockedGames: [CardGame] {
        GameUnlockService.unlockedGames(from: games, level: level)
    }

    private var activeGame: CardGame? {
        if let game, GameUnlockService.isUnlocked(game, level: level) { return game }
        if let picked = unlockedGames.first(where: { $0.slug == selectedDemoSlug }) {
            return picked
        }
        return unlockedGames.first
            ?? games.first(where: { $0.slug == "blackjack" })
            ?? games.first
    }

    private var isTabMode: Bool { game == nil }

    var body: some View {
        Group {
            if let activeGame {
                demoContent(for: activeGame)
            } else {
                ProgressView()
                    .tint(.jGold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.jBackground)
            }
        }
        .background(Color.jBackground)
        .navigationTitle(languageManager.text("tab.demo"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if game != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(languageManager.text("common.done")) { dismiss() }
                        .foregroundStyle(Color.jGold)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task(id: activeGame?.id) {
            if let activeGame {
                if isTabMode {
                    selectedDemoSlug = activeGame.slug
                }
                viewModel.markGameViewed(activeGame, context: modelContext, progress: progress)
                if viewModel.cards.isEmpty {
                    await viewModel.dealNewHand(reduceMotion: reduceMotion)
                }
            }
        }
        .alert(languageManager.text("common.error"), isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button(languageManager.text("common.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func demoContent(for activeGame: CardGame) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isOffline {
                    OfflineBanner()
                }

                if isTabMode, unlockedGames.count > 1 {
                    gamePicker(for: activeGame)
                }

                gameHeader(for: activeGame)

                CardTableView(
                    cards: viewModel.cards,
                    isLoading: viewModel.isLoading,
                    emptyHint: languageManager.text("demo.tapToDeal")
                )

                Button {
                    Task { await viewModel.dealNewHand(reduceMotion: reduceMotion) }
                } label: {
                    Text(languageManager.text("demo.dealAgain"))
                        .font(.display(18, relativeTo: .headline))
                        .foregroundStyle(Color.jBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.jGold)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .disabled(viewModel.isLoading)

                GoldDivider()
                    .padding(.horizontal)

                rulesSection(for: activeGame)

                if !activeGame.strategyTips.isEmpty {
                    strategyTipsSection(for: activeGame)
                }
            }
            .padding(.vertical)
            .adaptiveContentWidth()
        }
    }

    private func gamePicker(for activeGame: CardGame) -> some View {
        Menu {
            ForEach(unlockedGames, id: \.id) { game in
                Button {
                    selectedDemoSlug = game.slug
                    viewModel.cards = []
                } label: {
                    Text("\(game.emoji) \(game.name)")
                }
            }
        } label: {
            HStack {
                Text(languageManager.text("demo.chooseGame"))
                    .font(.bodyText(13, relativeTo: .subheadline))
                    .foregroundStyle(Color.jMuted)
                Spacer()
                Text("\(activeGame.emoji) \(activeGame.name)")
                    .font(.display(15, relativeTo: .subheadline))
                    .foregroundStyle(Color.jGold)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.jMuted)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.jCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.jBorder, lineWidth: 1))
        }
        .padding(.horizontal)
    }

    private func gameHeader(for activeGame: CardGame) -> some View {
        HStack {
            Text(activeGame.emoji)
                .font(.system(size: 36))
            VStack(alignment: .leading) {
                Text(activeGame.name)
                    .font(.display(24, relativeTo: .title2))
                    .foregroundStyle(Color.jGold)
                Text(
                    String(
                        format: languageManager.text("demo.playersCategory"),
                        "\(activeGame.minPlayers)",
                        "\(activeGame.maxPlayers)",
                        LocalizationService.shared.localizedCategory(activeGame.category)
                    )
                )
                .font(.bodyText(13, relativeTo: .subheadline))
                .foregroundStyle(Color.jMuted)
            }
            Spacer()

            Button {
                viewModel.toggleFavorite(activeGame, progress: progress, context: modelContext)
            } label: {
                Image(systemName: viewModel.isFavorite(activeGame, progress: progress) ? "star.fill" : "star")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.jGold)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                viewModel.isFavorite(activeGame, progress: progress)
                    ? languageManager.text("a11y.favorite.remove")
                    : languageManager.text("a11y.favorite.add")
            )

            ShareLink(item: GameShareFormatter.shareText(for: activeGame)) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jGold)
            }
            .accessibilityLabel(languageManager.text("share.rules"))
        }
        .padding(.horizontal)
    }

    private func rulesSection(for activeGame: CardGame) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(languageManager.text("demo.howToPlay"))
                .font(.display(18, relativeTo: .headline))
                .foregroundStyle(Color.jGold)

            ForEach(Array(activeGame.rules.enumerated()), id: \.offset) { index, rule in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.displayBold(14, relativeTo: .caption))
                        .foregroundStyle(Color.jBackground)
                        .frame(minWidth: 28, minHeight: 28)
                        .background(Color.jGold)
                        .clipShape(Circle())

                    Text(rule)
                        .font(.bodyText(15, relativeTo: .body))
                        .foregroundStyle(Color.jWhite)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal)
    }

    private func strategyTipsSection(for activeGame: CardGame) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            GoldDivider()

            DisclosureGroup(isExpanded: $showStrategyTips) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(activeGame.strategyTips.enumerated()), id: \.offset) { _, tip in
                        HStack(alignment: .top, spacing: 10) {
                            Text("★")
                                .foregroundStyle(Color.jGold)
                            Text(tip)
                                .font(.bodyText(15, relativeTo: .body))
                                .foregroundStyle(Color.jWhite)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.top, 8)
            } label: {
                Text(languageManager.text("collection.strategyTips"))
                    .font(.display(18, relativeTo: .headline))
                    .foregroundStyle(Color.jGold)
            }
            .tint(Color.jGold)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        DemoView()
    }
    .environment(\.languageManager, LanguageManager())
    .modelContainer(for: [CardGame.self, UserProgress.self], inMemory: true)
}
