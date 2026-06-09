import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.languageManager) private var languageManager
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CardGame.name) private var games: [CardGame]
    @Query private var progressRows: [UserProgress]
    @State private var viewModel = LibraryViewModel()
    @State private var demoGame: DemoGameSheetItem?
    @State private var lockedAlertMessage: String?

    private var progress: UserProgress? { progressRows.first }
    private var level: Int { progress?.level ?? 1 }
    private var favorites: Set<UUID> { Set(progress?.favoriteGameIDs ?? []) }

    private var sortedGames: [CardGame] {
        GameUnlockService.sortedByManifest(games)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GameUnlockBanner(level: level)
                    .padding(.horizontal)
                    .padding(.top, 8)

                filterChips
                    .padding(.vertical, 12)

                List {
                    ForEach(viewModel.filteredGames(from: sortedGames, favorites: favorites), id: \.id) { game in
                        let unlocked = GameUnlockService.isUnlocked(game, level: level)
                        HStack(spacing: 0) {
                            Button {
                                if unlocked {
                                    demoGame = DemoGameSheetItem(game: game)
                                } else if let next = GameUnlockService.nextTier(after: level) {
                                    lockedAlertMessage = String(
                                        format: languageManager.text("unlock.levelRequired"),
                                        "\(next.requiredLevel)"
                                    )
                                }
                            } label: {
                                GameRowView(game: game, isCatalogLocked: !unlocked)
                            }
                            .buttonStyle(.plain)

                            if unlocked {
                                Button {
                                    toggleFavorite(game)
                                } label: {
                                    Image(systemName: favorites.contains(game.id) ? "star.fill" : "star")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.jGold)
                                        .frame(width: 36, height: 36)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(
                                    favorites.contains(game.id)
                                        ? languageManager.text("a11y.favorite.remove")
                                        : languageManager.text("a11y.favorite.add")
                                )
                            }
                        }
                        .listRowBackground(Color.jSurface)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .adaptiveContentWidth()
            .background(Color.jBackground)
            .navigationTitle(languageManager.text("library.title"))
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .searchable(text: $viewModel.searchText, prompt: languageManager.text("search.games"))
            .sheet(item: $demoGame) { item in
                GameDemoSheet(game: item.game)
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

    private func toggleFavorite(_ game: CardGame) {
        guard let progress else { return }
        if progress.favoriteGameIDs.contains(game.id) {
            progress.favoriteGameIDs.removeAll { $0 == game.id }
        } else {
            progress.favoriteGameIDs.append(game.id)
        }
        try? modelContext.save()
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(LibraryFilter.allCases) { filter in
                    Button {
                        viewModel.selectedFilter = filter
                    } label: {
                        Text(languageManager.text(filter.localizationKey))
                            .font(.bodyText(13, relativeTo: .subheadline))
                            .foregroundStyle(
                                viewModel.selectedFilter == filter ? Color.jBackground : Color.jWhite
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedFilter == filter ? Color.jGold : Color.jCard
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.jBorder, lineWidth: viewModel.selectedFilter == filter ? 0 : 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(viewModel.selectedFilter == filter ? .isSelected : [])
                }
            }
            .padding(.horizontal)
        }
    }
}

private extension LibraryFilter {
    var localizationKey: String {
        switch self {
        case .all: return "filter.all"
        case .favorites: return "filter.favorites"
        case .twoPlayers: return "filter.twoPlayers"
        case .groups: return "filter.groups"
        case .solo: return "filter.solo"
        case .classic: return "filter.classic"
        case .family: return "filter.family"
        case .strategy: return "filter.strategy"
        case .trickTaking: return "filter.trickTaking"
        }
    }
}

#Preview {
    LibraryView()
        .environment(\.languageManager, LanguageManager())
        .modelContainer(for: CardGame.self, inMemory: true)
}
