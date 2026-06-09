import SwiftUI

struct DailyQuoteCard: View {
    let quote: Quote?
    let isLoading: Bool
    let title: String

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.jGold)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.display(14))
                    .foregroundStyle(Color.jGold)

                if isLoading {
                    Text("...")
                        .font(.bodyText(16))
                        .foregroundStyle(Color.jMuted)
                } else {
                    Text(quote?.content ?? "…")
                        .font(.bodyText(16))
                        .foregroundStyle(Color.jWhite)
                        .italic()

                    Text("— \(quote?.author ?? "—")")
                        .font(.bodyText(13))
                        .foregroundStyle(Color.jMuted)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .jokerCardStyle()
    }
}
