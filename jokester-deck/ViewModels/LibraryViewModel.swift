import Foundation

enum LibraryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case favorites = "Favorites"
    case twoPlayers = "2 Players"
    case groups = "Groups"
    case solo = "Solo"
    case classic = "Classic"
    case family = "Family"
    case strategy = "Strategy"
    case trickTaking = "Trick-Taking"

    var id: String { rawValue }
}

@Observable
@MainActor
final class LibraryViewModel {
    var searchText = ""
    var selectedFilter: LibraryFilter = .all

    func filteredGames(from games: [CardGame], favorites: Set<UUID>) -> [CardGame] {
        games.filter { game in
            matchesSearch(game) && matchesFilter(game, favorites: favorites)
        }
    }

    private func matchesSearch(_ game: CardGame) -> Bool {
        guard !searchText.isEmpty else { return true }
        let query = searchText.lowercased()
        return game.name.lowercased().contains(query)
            || LocalizationService.shared.localizedCategory(game.category).lowercased().contains(query)
    }

    private func matchesFilter(_ game: CardGame, favorites: Set<UUID>) -> Bool {
        switch selectedFilter {
        case .all:
            return true
        case .favorites:
            return favorites.contains(game.id)
        case .twoPlayers:
            return game.minPlayers == 2 && game.maxPlayers == 2
        case .groups:
            return game.maxPlayers >= 5
        case .solo:
            return game.minPlayers == 1
        case .classic:
            return game.category == "classic"
        case .family:
            return game.category == "family"
        case .strategy:
            return game.category == "strategy"
        case .trickTaking:
            return game.category == "trick_taking"
        }
    }
}
