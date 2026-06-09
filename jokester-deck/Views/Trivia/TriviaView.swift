import SwiftUI
import SwiftData

struct TriviaView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.languageManager) private var languageManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Query private var games: [CardGame]
    @Query private var progressRows: [UserProgress]

    @State private var viewModel = TriviaViewModel()
    @State private var didAwardXP = false

    private var progress: UserProgress? { progressRows.first }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.jBackground.ignoresSafeArea()

                switch viewModel.phase {
                case .loading:
                    loadingView
                case .error:
                    errorView
                case .playing:
                    playingView
                case .finished:
                    playingView
                        .overlay(resultsOverlay)
                }

                if viewModel.isOffline {
                    VStack {
                        OfflineBanner()
                            .padding(.top, 8)
                        Spacer()
                    }
                }
            }
            .navigationTitle(languageManager.text("tab.trivia"))
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task(id: languageManager.current) {
                didAwardXP = false
                await viewModel.loadQuestions(language: languageManager.current)
            }
            .onChange(of: viewModel.phase) { _, newPhase in
                if newPhase == .finished && !didAwardXP {
                    viewModel.awardXP(context: modelContext, progress: progress, games: games)
                    didAwardXP = true
                }
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.jGold)
                .scaleEffect(1.3)
            if !languageManager.current.usesLiveTriviaAPI {
                Text(languageManager.text("trivia.offlinePack"))
                    .font(.bodyText(13, relativeTo: .subheadline))
                    .foregroundStyle(Color.jMuted)
            }
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.jCard)
                    .frame(height: 48)
                    .padding(.horizontal)
            }
        }
        .adaptiveContentWidth()
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Text("🃏")
                .font(.system(size: 64))
                .accessibilityHidden(true)
            Text(languageManager.text("trivia.loadError"))
                .font(.display(20, relativeTo: .title2))
                .foregroundStyle(Color.jGold)
            Text(viewModel.errorMessage ?? languageManager.text("trivia.retry"))
                .font(.bodyText(14, relativeTo: .subheadline))
                .foregroundStyle(Color.jMuted)
                .multilineTextAlignment(.center)

            Button {
                didAwardXP = false
                Task { await viewModel.loadQuestions(language: languageManager.current) }
            } label: {
                Text(languageManager.text("trivia.retry"))
                    .font(.display(16, relativeTo: .headline))
                    .foregroundStyle(Color.jBackground)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.jGold)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .adaptiveContentWidth()
    }

    private var playingView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(languageManager.text("trivia.score")): \(viewModel.score)")
                    .font(.display(16, relativeTo: .headline))
                    .foregroundStyle(Color.jGold)
                    .accessibilityLabel(
                        String(
                            format: languageManager.text("a11y.trivia.score"),
                            "\(viewModel.score)",
                            "\(viewModel.questions.count)"
                        )
                    )
                Spacer()
                Text("\(min(viewModel.currentIndex + 1, viewModel.questions.count))/\(viewModel.questions.count)")
                    .font(.bodyText(14, relativeTo: .subheadline))
                    .foregroundStyle(Color.jMuted)
                    .accessibilityLabel(
                        String(
                            format: languageManager.text("a11y.trivia.questionProgress"),
                            "\(min(viewModel.currentIndex + 1, viewModel.questions.count))",
                            "\(viewModel.questions.count)"
                        )
                    )
            }
            .padding(.horizontal)

            triviaProgressBar
                .padding(.horizontal)

            if let question = viewModel.currentQuestion {
                Text(question.question)
                    .font(.bodyText(18, relativeTo: .title3))
                    .foregroundStyle(Color.jWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 10) {
                    ForEach(question.allAnswers, id: \.self) { answer in
                        AnswerButtonView(
                            text: answer,
                            isSelected: viewModel.selectedAnswer == answer,
                            isCorrect: viewModel.isLocked && answer == question.correctAnswer,
                            isWrong: viewModel.isLocked
                                && viewModel.selectedAnswer == answer
                                && answer != question.correctAnswer,
                            isLocked: viewModel.isLocked,
                            action: {
                                Task {
                                    await viewModel.selectAnswer(answer, reduceMotion: reduceMotion)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
        .adaptiveContentWidth()
    }

    private var triviaProgressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.jBorder)
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [.jGold, .jRed],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * viewModel.progress)
            }
        }
        .frame(height: 6)
        .progressAccessibility(
            label: languageManager.text("a11y.progress.trivia"),
            value: "\(Int(viewModel.progress * 100))%"
        )
    }

    private var resultsOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🃏")
                    .font(.system(size: 48))
                    .accessibilityHidden(true)

                Text(languageManager.text("trivia.roundComplete"))
                    .font(.display(24, relativeTo: .title))
                    .foregroundStyle(Color.jGold)

                Text("\(viewModel.score) / \(viewModel.questions.count)")
                    .font(.display(20, relativeTo: .title2))
                    .foregroundStyle(Color.jWhite)
                    .accessibilityLabel(
                        String(
                            format: languageManager.text("a11y.trivia.score"),
                            "\(viewModel.score)",
                            "\(viewModel.questions.count)"
                        )
                    )

                if viewModel.xpAwarded > 0 {
                    Text("+\(viewModel.xpAwarded) \(languageManager.text("trivia.xpEarned"))")
                        .font(.bodyText(16, relativeTo: .body))
                        .foregroundStyle(Color.jGoldLight)
                }

                Button {
                    didAwardXP = false
                    Task { await viewModel.loadQuestions(language: languageManager.current) }
                } label: {
                    Text(languageManager.text("trivia.playAgain"))
                        .font(.display(16, relativeTo: .headline))
                        .foregroundStyle(Color.jBackground)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.jGold)
                        .clipShape(Capsule())
                }
            }
            .padding(32)
            .jokerCardStyle()
            .padding()
            .accessibilityElement(children: .contain)
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    TriviaView()
        .environment(\.languageManager, LanguageManager())
        .modelContainer(for: [CardGame.self, UserProgress.self], inMemory: true)
}
