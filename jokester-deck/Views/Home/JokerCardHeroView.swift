import SwiftUI

struct JokerCardHeroView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @ScaledMetric(relativeTo: .title) private var cardWidth = 140.0
    @ScaledMetric(relativeTo: .title) private var cardHeight = 200.0

    @State private var floating = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: cardWidth, height: cardHeight)
                .shadow(color: .jGold.opacity(0.3), radius: 12, y: 8)

            VStack {
                HStack {
                    Text("J")
                        .font(.displayBold(14, relativeTo: .caption))
                        .foregroundStyle(Color.jGold)
                    Spacer()
                    Text("J")
                        .font(.displayBold(14, relativeTo: .caption))
                        .foregroundStyle(Color.jGold)
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)

                Spacer()

                Text("🃏")
                    .font(.system(size: 56))

                Spacer()

                HStack {
                    Text("J")
                        .font(.displayBold(14, relativeTo: .caption))
                        .foregroundStyle(Color.jGold)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    Text("J")
                        .font(.displayBold(14, relativeTo: .caption))
                        .foregroundStyle(Color.jGold)
                        .rotationEffect(.degrees(180))
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            }
            .frame(width: cardWidth, height: cardHeight)
        }
        .offset(y: reduceMotion ? 0 : (floating ? -8 : 8))
        .decorativeAccessibility()
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floating = true
            }
        }
    }
}

#Preview {
    JokerCardHeroView()
        .padding()
        .background(Color.jBackground)
}
