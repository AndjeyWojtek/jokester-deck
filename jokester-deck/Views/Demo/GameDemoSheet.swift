import SwiftUI

/// Wrapper so `.sheet(item:)` presents reliably (avoids empty gray sheet race with `isPresented`).
struct DemoGameSheetItem: Identifiable {
    let id: UUID
    let game: CardGame

    init(game: CardGame) {
        self.id = game.id
        self.game = game
    }
}

struct GameDemoSheet: View {
    let game: CardGame

    var body: some View {
        NavigationStack {
            DemoView(game: game)
        }
        .iPadSheetDetents()
    }
}
