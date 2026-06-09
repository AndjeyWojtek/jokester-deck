import SwiftUI

struct MasteryCardView: View {
    let game: CardGame
    let state: MasteryState

    @Environment(\.languageManager) private var languageManager

    @ScaledMetric(relativeTo: .caption) private var starSize = 10.0

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Text(game.emoji)
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .accessibilityHidden(true)

                if state == .mastered {
                    Text("🏆")
                        .font(.system(size: 16))
                        .offset(x: -4, y: 4)
                        .accessibilityHidden(true)
                } else if state == .catalogLocked || state == .locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.jMuted)
                        .offset(x: -8, y: 8)
                        .accessibilityHidden(true)
                }
            }

            Text(game.name)
                .font(.display(13, relativeTo: .subheadline))
                .foregroundStyle(Color.jWhite)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: index < game.masteryStars ? "star.fill" : "star")
                        .font(.system(size: starSize))
                        .foregroundStyle(index < game.masteryStars ? Color.jGold : Color.jBorder)
                }
            }
            .accessibilityHidden(true)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.jCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: state == .mastered ? 2 : 1)
        )
        .opacity(state == .locked || state == .catalogLocked ? 0.45 : 1)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        let stateText: String
        switch state {
        case .mastered:
            stateText = languageManager.text("a11y.mastery.mastered")
        case .catalogLocked, .locked:
            stateText = languageManager.text("a11y.mastery.locked")
        case .inProgress:
            stateText = languageManager.text("a11y.mastery.inProgress")
        }
        let stars = String(format: languageManager.text("a11y.mastery.stars"), "\(game.masteryStars)")
        return String(format: languageManager.text("a11y.mastery.card"), game.name, stars, stateText)
    }

    private var borderColor: Color {
        switch state {
        case .mastered: return .jGold
        case .inProgress: return .jBorder
        case .locked, .catalogLocked: return .jBorder
        }
    }
}

#Preview {
    HStack {
        MasteryCardView(
            game: CardGame(
                slug: "hearts",
                name: "Hearts",
                emoji: "♥️",
                categoryKey: "trick_taking",
                minPlayers: 4,
                maxPlayers: 4,
                difficultyLevel: 2,
                rules: [],
                strategyTips: [],
                isMastered: true,
                masteryStars: 3
            ),
            state: .mastered
        )
    }
    .padding()
    .background(Color.jBackground)
    .environment(\.languageManager, LanguageManager())
}
