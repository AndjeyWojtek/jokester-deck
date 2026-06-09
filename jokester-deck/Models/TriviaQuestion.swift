import Foundation

struct TriviaQuestion: Identifiable, Decodable {
    var id = UUID()
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    var allAnswers: [String]
    var category: String

    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case category
    }

    init(
        question: String,
        correctAnswer: String,
        incorrectAnswers: [String],
        category: String = "Entertainment"
    ) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.category = category
        self.allAnswers = (incorrectAnswers + [correctAnswer]).shuffled()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question).removingHTMLEntities()
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer).removingHTMLEntities()
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
            .map { $0.removingHTMLEntities() }
        category = (try? container.decode(String.self, forKey: .category)) ?? "Entertainment"
        allAnswers = (incorrectAnswers + [correctAnswer]).shuffled()
    }
}
