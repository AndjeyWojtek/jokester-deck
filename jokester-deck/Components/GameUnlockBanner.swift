import SwiftUI

struct GameUnlockBanner: View {
    @Environment(\.languageManager) private var languageManager
    let level: Int

    var body: some View {
        if let next = GameUnlockService.nextTier(after: level) {
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.jGold)
                Text(
                    String(
                        format: languageManager.text("unlock.banner"),
                        "\(next.requiredLevel)",
                        "\(next.gameCount)",
                        "\(GameUnlockService.totalCatalogCount)"
                    )
                )
                .font(.bodyText(13))
                .foregroundStyle(Color.jWhite)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.jCard)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.jGold.opacity(0.4), lineWidth: 1)
            )
        }
    }
}
