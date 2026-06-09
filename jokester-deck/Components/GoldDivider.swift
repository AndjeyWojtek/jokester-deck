import SwiftUI

struct GoldDivider: View {
    var body: some View {
        LinearGradient(
            colors: [.jGold, .jGold.opacity(0)],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
    }
}
