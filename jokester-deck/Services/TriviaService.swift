import Foundation

enum TriviaServiceError: LocalizedError {
    case invalidResponse
    case noResults
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return LocalizationService.shared.text("trivia.loadError")
        case .noResults:
            return LocalizationService.shared.text("trivia.loadError")
        case .networkError(let message):
            return message
        }
    }
}

struct TriviaService {
    func fetchQuestions(language: AppLanguage) async throws -> [TriviaQuestion] {
        if language.usesLiveTriviaAPI {
            do {
                return try await fetchFromOpenTDB()
            } catch {
                return try loadBundled(language: language)
            }
        }
        return try loadBundled(language: language)
    }

    private func fetchFromOpenTDB() async throws -> [TriviaQuestion] {
        let urlString = "https://opentdb.com/api.php?amount=10&category=14&type=multiple&encode=url3986"
        guard let url = URL(string: urlString) else {
            throw TriviaServiceError.invalidResponse
        }

        let data: Data
        do {
            let (responseData, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw TriviaServiceError.invalidResponse
            }
            data = responseData
        } catch let error as TriviaServiceError {
            throw error
        } catch {
            throw TriviaServiceError.networkError(error.localizedDescription)
        }

        let decoded = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
        guard decoded.responseCode == 0, !decoded.results.isEmpty else {
            throw TriviaServiceError.noResults
        }
        return decoded.results
    }

    private func loadBundled(language: AppLanguage) throws -> [TriviaQuestion] {
        guard let url = Bundle.main.url(forResource: "trivia-\(language.rawValue)", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw TriviaServiceError.noResults
        }

        let decoded = try JSONDecoder().decode([BundledTriviaQuestion].self, from: data)
        guard !decoded.isEmpty else { throw TriviaServiceError.noResults }

        return decoded.map { item in
            TriviaQuestion(
                question: item.question,
                correctAnswer: item.correctAnswer,
                incorrectAnswers: item.incorrectAnswers,
                category: item.category
            )
        }
    }
}

private struct TriviaAPIResponse: Decodable {
    let responseCode: Int
    let results: [TriviaQuestion]

    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

private struct BundledTriviaQuestion: Decodable {
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let category: String
}
