import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english = "en"
    case ukrainian = "uk"
    case hebrew = "he"
    case russian = "ru"
    case arabic = "ar"
    case chinese = "zh"
    case french = "fr"
    case german = "de"
    case spanish = "es"
    case japanese = "ja"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .ukrainian: return "Українська"
        case .hebrew: return "עברית"
        case .russian: return "Русский"
        case .arabic: return "العربية"
        case .chinese: return "中文"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .spanish: return "Español"
        case .japanese: return "日本語"
        }
    }

    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .ukrainian: return "uk"
        case .hebrew: return "he"
        case .russian: return "ru"
        case .arabic: return "ar"
        case .chinese: return "zh-Hans"
        case .french: return "fr"
        case .german: return "de"
        case .spanish: return "es"
        case .japanese: return "ja"
        }
    }

    var isRTL: Bool {
        self == .hebrew || self == .arabic
    }

    var usesLiveTriviaAPI: Bool {
        self == .english
    }

    static var stored: AppLanguage {
        let raw = UserDefaults.standard.string(forKey: Self.storageKey) ?? AppLanguage.english.rawValue
        return AppLanguage(rawValue: raw) ?? .english
    }

    static let storageKey = "appLanguage"
}
