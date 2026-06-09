import SwiftUI

struct CardTableView: View {
    let cards: [AnimatedCard]
    let isLoading: Bool
    var emptyHint: String = "Tap to deal"

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.languageManager) private var languageManager

    @ScaledMetric(relativeTo: .body) private var tableHeight = 180.0

    private let rotations: [Double] = [-16, -8, 0, 8, 16]

    private var cardSpacing: CGFloat {
        horizontalSizeClass == .regular ? -8 : -20
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#1A4D2E"), Color(hex: "#0F3320")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: tableHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "#2D6B45"), lineWidth: 2)
                )

            if cards.isEmpty && !isLoading {
                Text(emptyHint)
                    .font(.bodyText(14, relativeTo: .subheadline))
                    .foregroundStyle(Color.jWhite.opacity(0.7))
            } else {
                HStack(spacing: cardSpacing) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, animated in
                        PlayingCardView(
                            card: animated.card,
                            rotation: rotations[min(index, rotations.count - 1)]
                        )
                        .offset(y: animated.offsetY)
                        .opacity(animated.opacity)
                        .zIndex(Double(index))
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel(
                    String(format: languageManager.text("a11y.card.hand"), "\(cards.count)")
                )
            }

            if isLoading {
                ProgressView()
                    .tint(.jGold)
                    .scaleEffect(1.2)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CardTableView(
        cards: [
            AnimatedCard(
                card: DrawnCard(value: "A", suit: "Hearts", suitSymbol: "♥", isRed: true),
                offsetY: 0,
                opacity: 1
            )
        ],
        isLoading: false
    )
    .padding()
    .background(Color.jBackground)
    .environment(\.languageManager, LanguageManager())
}
