import SwiftUI

struct XPProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var label: String = ""

    private var progressLabel: String {
        "\(Int(min(max(progress, 0), 1) * 100))%"
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.jBorder)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(
                        LinearGradient(
                            colors: [.jGold, .jGoldLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * min(max(progress, 0), 1))
            }
        }
        .frame(height: height)
        .progressAccessibility(label: label, value: progressLabel)
    }
}
