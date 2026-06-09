import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
final class LanguageManager {
    var current: AppLanguage {
        didSet {
            guard oldValue != current else { return }
            UserDefaults.standard.set(current.rawValue, forKey: AppLanguage.storageKey)
            LocalizationService.shared.setLanguage(current)
        }
    }

    init(language: AppLanguage = .stored) {
        self.current = language
        LocalizationService.shared.setLanguage(language)
    }

    func text(_ key: String) -> String {
        LocalizationService.shared.text(key, language: current)
    }

    func applyLocalization(to context: ModelContext) async {
        await GameDataLoader.applyLocalization(language: current, context: context)
    }
}

private struct LanguageManagerKey: EnvironmentKey {
    static let defaultValue = LanguageManager()
}

extension EnvironmentValues {
    var languageManager: LanguageManager {
        get { self[LanguageManagerKey.self] }
        set { self[LanguageManagerKey.self] = newValue }
    }
}
