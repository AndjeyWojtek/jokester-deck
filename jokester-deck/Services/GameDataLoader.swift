import Foundation
import SwiftData

enum GameDataLoader {
    private static let seedKey = "didSeedData"
    private static let slugMigrationKey = "didMigrateSlugs"

    struct ManifestEntry: Decodable {
        let slug: String
        let emoji: String
        let categoryKey: String
        let minPlayers: Int
        let maxPlayers: Int
        let difficulty: Int
    }

    static func seedIfNeeded(context: ModelContext) async {
        let language = AppLanguage.stored
        let gameCount = (try? context.fetchCount(FetchDescriptor<CardGame>())) ?? 0

        if !UserDefaults.standard.bool(forKey: seedKey) || gameCount == 0 {
            if gameCount > 0 {
                try? context.delete(model: CardGame.self)
            }
            await seedFromManifest(context: context, language: language)
            UserDefaults.standard.set(true, forKey: seedKey)
        }

        if !UserDefaults.standard.bool(forKey: slugMigrationKey) {
            await migrateLegacyGames(context: context, language: language)
            UserDefaults.standard.set(true, forKey: slugMigrationKey)
        }

        await syncMissingGames(context: context, language: language)
        await applyLocalization(language: language, context: context)
    }

    static func applyLocalization(language: AppLanguage, context: ModelContext) async {
        LocalizationService.shared.setLanguage(language)
        guard let manifest = loadManifest() else { return }

        let descriptor = FetchDescriptor<CardGame>()
        let games = (try? context.fetch(descriptor)) ?? []
        let gamesBySlug = Dictionary(uniqueKeysWithValues: games.map { ($0.slug, $0) })

        for entry in manifest {
            guard let translation = LocalizationService.shared.gameTranslation(for: entry.slug, language: language) else {
                continue
            }

            if let game = gamesBySlug[entry.slug] {
                game.name = translation.name
                game.rules = translation.rules
                game.strategyTips = translation.strategyTips
                game.category = entry.categoryKey
                game.emoji = entry.emoji
            }
        }

        try? context.save()
    }

    static func decodeGameCount(from data: Data) -> Int {
        guard let manifest = try? JSONDecoder().decode([ManifestEntry].self, from: data) else {
            return 0
        }
        return manifest.count
    }

    private static func syncMissingGames(context: ModelContext, language: AppLanguage) async {
        guard let manifest = loadManifest() else { return }
        LocalizationService.shared.setLanguage(language)

        let existing = Set((try? context.fetch(FetchDescriptor<CardGame>()))?.map(\.slug) ?? [])

        for entry in manifest where !existing.contains(entry.slug) {
            guard let translation = LocalizationService.shared.gameTranslation(for: entry.slug, language: language)
                ?? LocalizationService.shared.gameTranslation(for: entry.slug, language: .english) else {
                continue
            }

            context.insert(
                CardGame(
                    slug: entry.slug,
                    name: translation.name,
                    emoji: entry.emoji,
                    categoryKey: entry.categoryKey,
                    minPlayers: entry.minPlayers,
                    maxPlayers: entry.maxPlayers,
                    difficultyLevel: entry.difficulty,
                    rules: translation.rules,
                    strategyTips: translation.strategyTips
                )
            )
        }

        try? context.save()
    }

    private static func seedFromManifest(context: ModelContext, language: AppLanguage) async {
        guard let manifest = loadManifest() else { return }
        LocalizationService.shared.setLanguage(language)

        for entry in manifest {
            guard let translation = LocalizationService.shared.gameTranslation(for: entry.slug, language: language)
                ?? LocalizationService.shared.gameTranslation(for: entry.slug, language: .english) else {
                continue
            }

            let game = CardGame(
                slug: entry.slug,
                name: translation.name,
                emoji: entry.emoji,
                categoryKey: entry.categoryKey,
                minPlayers: entry.minPlayers,
                maxPlayers: entry.maxPlayers,
                difficultyLevel: entry.difficulty,
                rules: translation.rules,
                strategyTips: translation.strategyTips
            )
            context.insert(game)
        }

        let progressDescriptor = FetchDescriptor<UserProgress>()
        if (try? context.fetch(progressDescriptor))?.isEmpty != false {
            context.insert(UserProgress())
        }

        try? context.save()
    }

    private static func migrateLegacyGames(context: ModelContext, language: AppLanguage) async {
        guard let manifest = loadManifest() else { return }
        LocalizationService.shared.setLanguage(.english)

        let descriptor = FetchDescriptor<CardGame>()
        let games = (try? context.fetch(descriptor)) ?? []
        guard !games.isEmpty, games.allSatisfy({ $0.slug.isEmpty }) else { return }

        let englishNames = manifest.compactMap { entry -> (String, ManifestEntry)? in
            guard let t = LocalizationService.shared.gameTranslation(for: entry.slug, language: .english) else {
                return nil
            }
            return (t.name, entry)
        }
        let byName = Dictionary(uniqueKeysWithValues: englishNames)

        for game in games {
            if let entry = byName[game.name] {
                game.slug = entry.slug
                game.category = entry.categoryKey
            } else {
                game.category = Self.normalizeCategoryKey(game.category)
            }
        }

        try? context.save()
        await applyLocalization(language: language, context: context)
    }

    private static func loadManifest() -> [ManifestEntry]? {
        guard let url = Bundle.main.url(forResource: "GamesManifest", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return try? JSONDecoder().decode([ManifestEntry].self, from: data)
    }

    private static func normalizeCategoryKey(_ value: String) -> String {
        switch value {
        case "Classic": return "classic"
        case "Family": return "family"
        case "Strategy": return "strategy"
        case "Trick-Taking": return "trick_taking"
        default: return value
        }
    }
}
