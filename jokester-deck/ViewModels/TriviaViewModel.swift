import Foundation
import SwiftData
import SwiftUI
import UIKit

enum TriviaPhase {
    case loading
    case playing
    case finished
    case error
}

@Observable
@MainActor
final class TriviaViewModel {
    var questions: [TriviaQuestion] = []
    var currentIndex = 0
    var score = 0
    var selectedAnswer: String?
    var isLocked = false
    var phase: TriviaPhase = .loading
    var errorMessage: String?
    var isOffline = false
    var xpAwarded = 0
    var correctPulse = false

    private let triviaService = TriviaService()

    var currentQuestion: TriviaQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    func loadQuestions(language: AppLanguage) async {
        phase = .loading
        errorMessage = nil
        currentIndex = 0
        score = 0
        selectedAnswer = nil
        isLocked = false
        xpAwarded = 0

        do {
            questions = try await triviaService.fetchQuestions(language: language)
            isOffline = false
            phase = .playing
        } catch {
            errorMessage = error.localizedDescription
            if (error as? URLError)?.code == .notConnectedToInternet {
                isOffline = true
            }
            phase = .error
        }
    }

    func selectAnswer(_ answer: String, reduceMotion: Bool = false) async {
        guard !isLocked, let question = currentQuestion else { return }
        isLocked = true
        selectedAnswer = answer

        if answer == question.correctAnswer {
            score += 1
            correctPulse = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if !reduceMotion {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    correctPulse = false
                }
            } else {
                correctPulse = false
            }
        }

        try? await Task.sleep(for: .milliseconds(1200))

        if currentIndex + 1 >= questions.count {
            phase = .finished
        } else {
            currentIndex += 1
            selectedAnswer = nil
            isLocked = false
        }
    }

    func awardXP(context: ModelContext, progress: UserProgress?, games: [CardGame]) {
        guard let progress, phase == .finished else { return }

        let earned = score * 10
        xpAwarded = earned
        progress.totalXP += earned
        progress.triviaCorrect += score
        progress.triviaTotal += questions.count
        progress.lastPlayedDate = .now

        if score >= 7, let randomGame = games.randomElement(),
           !progress.triviaCompletedGames.contains(randomGame.id) {
            progress.triviaCompletedGames.append(randomGame.id)
            randomGame.masteryStars = min(randomGame.masteryStars + 1, 3)
            randomGame.isMastered = randomGame.masteryStars >= 3
        }

        try? context.save()
    }
}
