//
//  jokester_deckTests.swift
//  jokester-deckTests
//

import Testing
import SwiftUI
@testable import jokester_deck

struct jokester_deckTests {

    @Test func colorHexParsesSixDigit() {
        let color = Color(hex: "#C9A84C")
        #expect(color != Color.clear)
    }

    @Test func htmlEntitiesDecoded() {
        let input = "Who%27s%20the%20best%3F"
        let decoded = input.removingHTMLEntities()
        #expect(decoded.contains("'"))
    }

    @Test func gameManifestDecodes100Games() throws {
        let url = Bundle.main.url(forResource: "GamesManifest", withExtension: "json")
        #expect(url != nil)
        let data = try Data(contentsOf: url!)
        let count = GameDataLoader.decodeGameCount(from: data)
        #expect(count == 100)
    }

    @Test func uiStringsAvailableForAllLanguages() {
        for language in AppLanguage.allCases {
            LocalizationService.shared.setLanguage(language)
            #expect(!LocalizationService.shared.text("tab.home", language: language).isEmpty)
            #expect(!LocalizationService.shared.text("settings.language", language: language).isEmpty)
        }
    }

    @Test func gameTranslationsExistForAllLanguages() {
        for language in AppLanguage.allCases {
            LocalizationService.shared.setLanguage(language)
            let translation = LocalizationService.shared.gameTranslation(for: "blackjack", language: language)
            #expect(translation != nil)
            #expect(translation?.rules.count == 3)
        }
    }
}
