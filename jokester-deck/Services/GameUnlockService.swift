import Foundation

enum GameUnlockService {
    /// Level thresholds: more games unlock as the player levels up.
    private static let tiers: [(minLevel: Int, gameCount: Int)] = [
        (1, 25),
        (3, 50),
        (6, 100)
    ]

    private static var manifestSlugs: [String] = {
        guard let url = Bundle.main.url(forResource: "GamesManifest", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([ManifestSlug].self, from: data) else {
            return []
        }
        return entries.map(\.slug)
    }()

    static var totalCatalogCount: Int {
        manifestSlugs.count
    }

    static func unlockedCount(for level: Int) -> Int {
        let tierCount = tiers.last(where: { level >= $0.minLevel })?.gameCount ?? tiers[0].gameCount
        return min(tierCount, manifestSlugs.count)
    }

    static func isUnlocked(slug: String, level: Int) -> Bool {
        guard let index = manifestSlugs.firstIndex(of: slug) else { return false }
        return index < unlockedCount(for: level)
    }

    static func isUnlocked(_ game: CardGame, level: Int) -> Bool {
        isUnlocked(slug: game.slug, level: level)
    }

    static func nextTier(after level: Int) -> (requiredLevel: Int, gameCount: Int)? {
        tiers.first(where: { level < $0.minLevel }).map { ($0.minLevel, $0.gameCount) }
    }

    static func manifestOrder(of slug: String) -> Int {
        manifestSlugs.firstIndex(of: slug) ?? Int.max
    }

    static func sortedByManifest(_ games: [CardGame]) -> [CardGame] {
        games.sorted { manifestOrder(of: $0.slug) < manifestOrder(of: $1.slug) }
    }

    static func unlockedGames(from games: [CardGame], level: Int) -> [CardGame] {
        sortedByManifest(games).filter { isUnlocked($0, level: level) }
    }
}

private struct ManifestSlug: Decodable {
    let slug: String
}
