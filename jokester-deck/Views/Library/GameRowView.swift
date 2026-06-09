import SwiftUI

struct GameRowView: View {
    let game: CardGame
    var isCatalogLocked: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Text(game.emoji)
                .font(.system(size: 28))
                .frame(width: 40)
                .opacity(isCatalogLocked ? 0.35 : 1)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(game.name)
                        .font(.display(16, relativeTo: .headline))
                        .foregroundStyle(Color.jWhite)

                    if isCatalogLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.jMuted)
                            .accessibilityHidden(true)
                    }
                }

                HStack(spacing: 8) {
                    Text("\(game.minPlayers)–\(game.maxPlayers) \(LocalizationService.shared.text("common.players"))")
                        .font(.bodyText(12, relativeTo: .caption))
                        .foregroundStyle(Color.jMuted)

                    Text(LocalizationService.shared.localizedCategory(game.category))
                        .font(.bodyText(11, relativeTo: .caption2))
                        .foregroundStyle(Color.jGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.jGold.opacity(0.15))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            DifficultyDots(level: game.difficultyLevel)
        }
        .padding(.vertical, 8)
        .opacity(isCatalogLocked ? 0.55 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let lockState = isCatalogLocked
            ? LocalizationService.shared.text("a11y.game.locked")
            : LocalizationService.shared.text("a11y.game.unlocked")
        let difficulty = difficultyLabel(for: game.difficultyLevel)
        let category = LocalizationService.shared.localizedCategory(game.category)
        return String(
            format: LocalizationService.shared.text("a11y.game.row"),
            game.name,
            "\(game.minPlayers)",
            "\(game.maxPlayers)",
            category,
            difficulty,
            lockState
        )
    }

    private func difficultyLabel(for level: Int) -> String {
        switch level {
        case 1: return LocalizationService.shared.text("a11y.difficulty.easy")
        case 2: return LocalizationService.shared.text("a11y.difficulty.medium")
        default: return LocalizationService.shared.text("a11y.difficulty.hard")
        }
    }
}

struct DifficultyDots: View {
    let level: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...3, id: \.self) { index in
                Circle()
                    .fill(index <= level ? dotColor(for: index) : Color.jBorder)
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityHidden(true)
    }

    private func dotColor(for index: Int) -> Color {
        level >= 3 && index == 3 ? .jRed : .jGold
    }
}
