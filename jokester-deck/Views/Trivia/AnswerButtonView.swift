import SwiftUI

struct AnswerButtonView: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let isLocked: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.languageManager) private var languageManager

    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.bodyText(15, relativeTo: .body))
                .foregroundStyle(textColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
                )
                .scaleEffect(reduceMotion ? 1.0 : (pulse ? 1.04 : 1.0))
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
        .accessibilityValue(accessibilityValue)
        .onChange(of: isCorrect) { _, newValue in
            guard !reduceMotion else { return }
            if newValue && isSelected {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    pulse = true
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.15)) {
                    pulse = false
                }
            }
        }
    }

    private var accessibilityValue: String {
        guard isLocked else { return "" }
        if isCorrect { return languageManager.text("a11y.trivia.correct") }
        if isWrong { return languageManager.text("a11y.trivia.incorrect") }
        return ""
    }

    private var backgroundColor: Color {
        if isCorrect { return Color.green.opacity(0.25) }
        if isWrong { return Color.jRed.opacity(0.25) }
        return Color.jCard
    }

    private var borderColor: Color {
        if isCorrect { return .green }
        if isWrong { return .jRed }
        if isSelected { return .jGold }
        return .jBorder
    }

    private var textColor: Color {
        if isCorrect || isWrong { return .jWhite }
        return .jWhite
    }
}

#Preview {
    VStack {
        AnswerButtonView(
            text: "Sample answer",
            isSelected: true,
            isCorrect: true,
            isWrong: false,
            isLocked: true,
            action: {}
        )
    }
    .padding()
    .background(Color.jBackground)
    .environment(\.languageManager, LanguageManager())
}
