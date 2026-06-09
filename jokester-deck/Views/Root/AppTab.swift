import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable, Hashable {
    case home
    case codex
    case demo
    case trivia
    case collection

    var id: Int { rawValue }

    func title(using languageManager: LanguageManager) -> String {
        switch self {
        case .home: return languageManager.text("tab.home")
        case .codex: return languageManager.text("tab.codex")
        case .demo: return languageManager.text("tab.demo")
        case .trivia: return languageManager.text("tab.trivia")
        case .collection: return languageManager.text("tab.collection")
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "suit.club.fill"
        case .codex: return "books.vertical.fill"
        case .demo: return "rectangle.stack.fill"
        case .trivia: return "questionmark.circle.fill"
        case .collection: return "star.fill"
        }
    }
}
