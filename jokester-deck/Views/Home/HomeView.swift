import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.languageManager) private var languageManager
    @Query private var games: [CardGame]
    @Query private var progressRows: [UserProgress]

    @State private var viewModel = HomeViewModel()
    @State private var demoGame: DemoGameSheetItem?
    @State private var showSettings = false

    private var progress: UserProgress? { progressRows.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.isOffline {
                        OfflineBanner()
                    }

                    JokerCardHeroView()

                    Text(languageManager.text("home.title"))
                        .font(.display(28, relativeTo: .largeTitle))
                        .foregroundStyle(Color.jGold)

                    SuitDecoration()

                    DailyQuoteCard(
                        quote: viewModel.quote,
                        isLoading: viewModel.isLoadingQuote,
                        title: languageManager.text("quote.dailyWisdom")
                    )

                    statsRow

                    if let featured = viewModel.featuredGame {
                        featuredGameCard(featured)
                    }
                }
                .padding()
                .adaptiveContentWidth()
            }
            .background(
                RadialGradient(
                    colors: [Color.jGold.opacity(0.15), Color.jBackground],
                    center: .top,
                    startRadius: 0,
                    endRadius: 400
                )
                .ignoresSafeArea()
            )
            .background(Color.jBackground)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "globe")
                            .foregroundStyle(Color.jGold)
                    }
                    .accessibilityLabel(languageManager.text("a11y.settings.language"))
                }
            }
            .task(id: languageManager.current) {
                await viewModel.loadQuote(language: languageManager.current)
                viewModel.pickFeaturedGame(from: games, level: progress?.level ?? 1)
            }
            .onChange(of: progress?.totalXP) { _, _ in
                viewModel.pickFeaturedGame(from: games, level: progress?.level ?? 1)
            }
            .sheet(item: $demoGame) { item in
                GameDemoSheet(game: item.game)
                    .iPadSheetDetents()
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .iPadSheetDetents()
            }
        }
    }

    private var statsRow: some View {
        let level = progress?.level ?? 1
        let unlocked = GameUnlockService.unlockedCount(for: level)
        return HStack(spacing: 12) {
            statPill(
                title: languageManager.text("stat.unlocked"),
                value: "\(unlocked)/\(GameUnlockService.totalCatalogCount)"
            )
            statPill(title: languageManager.text("stat.mastered"), value: "\(games.filter(\.isMastered).count)")
            statPill(title: languageManager.text("stat.xp"), value: "\(progress?.totalXP ?? 0)")
        }
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.displayBold(20, relativeTo: .title3))
                .foregroundStyle(Color.jGold)
            Text(title)
                .font(.bodyText(12, relativeTo: .caption))
                .foregroundStyle(Color.jMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .jokerCardStyle()
    }

    private func featuredGameCard(_ game: CardGame) -> some View {
        Button {
            demoGame = DemoGameSheetItem(game: game)
        } label: {
            HStack {
                Text(game.emoji)
                    .font(.system(size: 32))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(languageManager.text("home.featuredGame"))
                        .font(.bodyText(12, relativeTo: .caption))
                        .foregroundStyle(Color.jMuted)
                    Text(game.name)
                        .font(.display(18, relativeTo: .headline))
                        .foregroundStyle(Color.jWhite)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.jGold)
                    .accessibilityHidden(true)
            }
            .padding(16)
            .jokerCardStyle()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            String(format: languageManager.text("a11y.featuredGame"), game.name)
        )
    }
}

#Preview {
    HomeView()
        .environment(\.languageManager, LanguageManager())
        .modelContainer(for: [CardGame.self, UserProgress.self], inMemory: true)
}
