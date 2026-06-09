import Foundation

struct DrawnCard: Identifiable, Equatable {
    let id = UUID()
    let value: String
    let suit: String
    let suitSymbol: String
    let isRed: Bool
}

enum DeckAPIError: LocalizedError {
    case invalidResponse
    case decodingFailed
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The card server returned an unexpected response."
        case .decodingFailed:
            return "Could not read the card data."
        case .networkError(let message):
            return message
        }
    }
}

struct DeckAPIService {
    private let baseURL = "https://deckofcardsapi.com/api/deck"

    func shuffleDeck() async throws -> String {
        let url = URL(string: "\(baseURL)/new/shuffle/?deck_count=1")!
        let data = try await fetchData(from: url)
        let response = try decode(ShuffleResponse.self, from: data)
        return response.deckID
    }

    func drawCards(deckId: String, count: Int) async throws -> [DrawnCard] {
        let url = URL(string: "\(baseURL)/\(deckId)/draw/?count=\(count)")!
        let data = try await fetchData(from: url)
        let response = try decode(DrawResponse.self, from: data)
        return response.cards.map(mapCard)
    }

    private func fetchData(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw DeckAPIError.invalidResponse
            }
            return data
        } catch let error as DeckAPIError {
            throw error
        } catch {
            throw DeckAPIError.networkError(error.localizedDescription)
        }
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw DeckAPIError.decodingFailed
        }
    }

    private func mapCard(_ card: APICard) -> DrawnCard {
        let suitSymbol: String
        let isRed: Bool
        switch card.suit.uppercased() {
        case "SPADES":
            suitSymbol = "♠"
            isRed = false
        case "HEARTS":
            suitSymbol = "♥"
            isRed = true
        case "DIAMONDS":
            suitSymbol = "♦"
            isRed = true
        case "CLUBS":
            suitSymbol = "♣"
            isRed = false
        default:
            suitSymbol = "?"
            isRed = false
        }

        let value: String
        switch card.value.uppercased() {
        case "ACE": value = "A"
        case "KING": value = "K"
        case "QUEEN": value = "Q"
        case "JACK": value = "J"
        default: value = card.value
        }

        return DrawnCard(value: value, suit: card.suit, suitSymbol: suitSymbol, isRed: isRed)
    }
}

private struct ShuffleResponse: Decodable {
    let deckID: String

    enum CodingKeys: String, CodingKey {
        case deckID = "deck_id"
    }
}

private struct DrawResponse: Decodable {
    let cards: [APICard]
}

private struct APICard: Decodable {
    let value: String
    let suit: String
}
