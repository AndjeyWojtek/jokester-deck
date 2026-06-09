import SwiftUI
import SwiftData

struct CollectionView: View {
    @Environment(\.languageManager) private var languageManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Query(sort: \CardGame.name) private var games: [CardGame]
    @Query private var progressRows: [UserProgress]

    @State private var viewModel = CollectionViewModel()
    @State private var selectedGame: CardGame?
    @State private var showTips = false
    @State private var lockedAlertMessage: String?

    private var progress: UserProgress? { progressRows.first }

    private var columns: [GridItem] {
        if horizontalSizeClass == .regular {
            [GridItem(.adaptive(minimum: 160), spacing: 12)]
        } else {
            [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    levelHeader

                    GameUnlockBanner(level: progress?.level ?? 1)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(GameUnlockService.sortedByManifest(games), id: \.id) { game in
                            let state = viewModel.masteryState(for: game, progress: progress)
                            Button {
                                if state == .mastered {
                                    selectedGame = game
                                    showTips = true
                                } else if state == .catalogLocked,
                                          let next = GameUnlockService.nextTier(after: progress?.level ?? 1) {
                                    lockedAlertMessage = String(
                                        format: languageManager.text("unlock.levelRequired"),
                                        "\(next.requiredLevel)"
                                    )
                                }
                            } label: {
                                MasteryCardView(game: game, state: state)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
                .adaptiveContentWidth()
            }
            .background(Color.jBackground)
            .navigationTitle(languageManager.text("tab.collection"))
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showTips) {
                if let game = selectedGame {
                    strategyTipsSheet(for: game)
                }
            }
            .alert(languageManager.text("unlock.lockedByLevel"), isPresented: Binding(
                get: { lockedAlertMessage != nil },
                set: { if !$0 { lockedAlertMessage = nil } }
            )) {
                Button(languageManager.text("common.ok"), role: .cancel) {}
            } message: {
                Text(lockedAlertMessage ?? "")
            }
        }
    }

    private var levelHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Text("\(languageManager.text("collection.level")) \(viewModel.level(for: progress))")
                    .font(.display(20, relativeTo: .title3))
                    .foregroundStyle(Color.jGold)
                Spacer()
                Text("\(progress?.xpInCurrentLevel ?? 0)/50 \(languageManager.text("stat.xp"))")
                    .font(.bodyText(13, relativeTo: .subheadline))
                    .foregroundStyle(Color.jMuted)
            }

            XPProgressBar(
                progress: viewModel.xpProgress(for: progress),
                label: languageManager.text("a11y.progress.xp")
            )
        }
        .padding(16)
        .jokerCardStyle()
    }

    private func strategyTipsSheet(for game: CardGame) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(game.emoji)
                            .font(.system(size: 40))
                        Text(game.name)
                            .font(.display(22, relativeTo: .title2))
                            .foregroundStyle(Color.jGold)
                    }

                    GoldDivider()

                    Text(languageManager.text("collection.strategyTips"))
                        .font(.display(16, relativeTo: .headline))
                        .foregroundStyle(Color.jGoldLight)

                    ForEach(Array(game.strategyTips.enumerated()), id: \.offset) { _, tip in
                        HStack(alignment: .top, spacing: 10) {
                            Text("★")
                                .foregroundStyle(Color.jGold)
                            Text(tip)
                                .font(.bodyText(15, relativeTo: .body))
                                .foregroundStyle(Color.jWhite)
                        }
                    }
                }
                .padding()
            }
            .background(Color.jBackground)
            .navigationTitle(languageManager.text("collection.mastery"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(languageManager.text("common.done")) { showTips = false }
                        .foregroundStyle(Color.jGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .iPadSheetDetents()
        }
    }
}

#Preview {
    CollectionView()
        .environment(\.languageManager, LanguageManager())
        .modelContainer(for: [CardGame.self, UserProgress.self], inMemory: true)
}
