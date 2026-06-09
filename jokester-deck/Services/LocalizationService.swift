import Foundation

final class LocalizationService {
    static let shared = LocalizationService()

    private var uiStrings: [String: [String: String]] = [:]
    private var gameStrings: [String: [String: GameTranslation]] = [:]
    private var quoteStrings: [String: [Quote]] = [:]
    private var language: AppLanguage = .stored

    private init() {
        loadUIStrings()
        loadQuoteStrings()
        loadGameStrings(for: .english)
    }

    func setLanguage(_ language: AppLanguage) {
        self.language = language
        if gameStrings[language.rawValue] == nil {
            loadGameStrings(for: language)
        }
    }

    func text(_ key: String, language: AppLanguage? = nil) -> String {
        let lang = (language ?? self.language).rawValue
        return uiStrings[lang]?[key] ?? uiStrings[AppLanguage.english.rawValue]?[key] ?? key
    }

    func gameTranslation(for slug: String, language: AppLanguage? = nil) -> GameTranslation? {
        let lang = (language ?? self.language).rawValue
        if gameStrings[lang] == nil { loadGameStrings(for: AppLanguage(rawValue: lang) ?? .english) }
        return gameStrings[lang]?[slug] ?? gameStrings[AppLanguage.english.rawValue]?[slug]
    }

    func localizedCategory(_ categoryKey: String, language: AppLanguage? = nil) -> String {
        text("category.\(categoryKey)", language: language)
    }

    func fallbackQuotes(for language: AppLanguage? = nil) -> [Quote] {
        let lang = (language ?? self.language).rawValue
        return quoteStrings[lang] ?? quoteStrings[AppLanguage.english.rawValue] ?? []
    }

    private func loadUIStrings() {
        guard let url = Bundle.main.url(forResource: "UIStrings", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data) else {
            return
        }
        uiStrings = decoded
    }

    private func loadGameStrings(for language: AppLanguage) {
        let code = language.rawValue
        guard gameStrings[code] == nil,
              let url = Bundle.main.url(forResource: "games-\(code)", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: GameTranslation].self, from: data) else {
            return
        }
        gameStrings[code] = decoded
    }

    private func loadQuoteStrings() {
        guard let url = Bundle.main.url(forResource: "Quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: [QuoteDTO]].self, from: data) else {
            return
        }
        quoteStrings = decoded.mapValues { $0.map { Quote(content: $0.content, author: $0.author) } }
    }
}

struct GameTranslation: Decodable {
    let name: String
    let rules: [String]
    let strategyTips: [String]
}

private struct QuoteDTO: Decodable {
    let content: String
    let author: String
}
