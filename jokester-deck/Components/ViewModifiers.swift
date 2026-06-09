import SwiftUI

struct JokerCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.jCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.jBorder, lineWidth: 1)
            )
    }
}

struct AdaptiveContentWidth: ViewModifier {
    @Environment(\.horizontalSizeClass) private var sizeClass

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: sizeClass == .regular ? 720 : .infinity)
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func jokerCardStyle() -> some View {
        modifier(JokerCardStyle())
    }

    func adaptiveContentWidth() -> some View {
        modifier(AdaptiveContentWidth())
    }

    func decorativeAccessibility() -> some View {
        accessibilityHidden(true)
    }

    func progressAccessibility(label: String, value: String) -> some View {
        accessibilityElement(children: .ignore)
            .accessibilityLabel(label)
            .accessibilityValue(value)
    }

    func iPadSheetDetents() -> some View {
        presentationDetents([.large])
    }
}

struct OfflineBanner: View {
    var body: some View {
        Text(LocalizationService.shared.text("common.offline"))
            .font(.bodyText(12, relativeTo: .caption))
            .foregroundStyle(Color.jGold)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.jSurface)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.jGold.opacity(0.5), lineWidth: 1))
    }
}
