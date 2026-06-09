import SwiftUI

struct PlayingCardView: View {
    let card: DrawnCard
    let rotation: Double

    @Environment(\.languageManager) private var languageManager

    @ScaledMetric(relativeTo: .body) private var cardWidth = 70.0
    @ScaledMetric(relativeTo: .body) private var cardHeight = 100.0

    private var blackSuitColor: Color {
        GrowthBookService.shared.allowsGreyPart ? .jMuted : .jBackground
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)

            VStack(spacing: 4) {
                HStack {
                    Text(card.value)
                        .font(.displayBold(16, relativeTo: .body))
                        .foregroundStyle(card.isRed ? Color.jRed : blackSuitColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)

                Spacer()

                Text(card.suitSymbol)
                    .font(.system(size: 28))
                    .foregroundStyle(card.isRed ? Color.jRed : blackSuitColor)

                Spacer()

                HStack {
                    Spacer()
                    Text(card.value)
                        .font(.displayBold(16, relativeTo: .body))
                        .foregroundStyle(card.isRed ? Color.jRed : blackSuitColor)
                        .rotationEffect(.degrees(180))
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .rotationEffect(.degrees(rotation))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            String(format: languageManager.text("a11y.card.description"), card.value, card.suit)
        )
    }
}

#Preview {
    HStack {
        PlayingCardView(
            card: DrawnCard(value: "A", suit: "Hearts", suitSymbol: "♥", isRed: true),
            rotation: -8
        )
        PlayingCardView(
            card: DrawnCard(value: "K", suit: "Spades", suitSymbol: "♠", isRed: false),
            rotation: 8
        )
    }
    .padding()
    .background(Color.jBackground)
    .environment(\.languageManager, LanguageManager())
}
