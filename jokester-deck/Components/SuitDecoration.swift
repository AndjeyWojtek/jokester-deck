import SwiftUI

struct SuitDecoration: View {
    private var blackSuitColor: Color {
        GrowthBookService.shared.allowsGreyPart ? .jMuted : .jWhite
    }

    var body: some View {
        HStack(spacing: 16) {
            Text("♠").foregroundStyle(blackSuitColor)
            Text("♥").foregroundStyle(Color.jRed)
            Text("♦").foregroundStyle(Color.jRed)
            Text("♣").foregroundStyle(blackSuitColor)
        }
        .font(.bodyText(18, relativeTo: .body))
        .decorativeAccessibility()
    }
}
