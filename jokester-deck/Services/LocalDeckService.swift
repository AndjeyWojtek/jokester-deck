import Foundation

struct LocalDeckService {
    private var deck: [DrawnCard] = []

    mutating func reshuffle() {
        deck = Self.standardDeck.shuffled()
    }

    mutating func draw(count: Int) -> [DrawnCard] {
        if deck.count < count {
            reshuffle()
        }
        let drawn = Array(deck.prefix(count))
        deck.removeFirst(min(count, deck.count))
        return drawn
    }

    private static let standardDeck: [DrawnCard] = {
        let suits: [(name: String, symbol: String, isRed: Bool)] = [
            ("SPADES", "♠", false),
            ("HEARTS", "♥", true),
            ("DIAMONDS", "♦", true),
            ("CLUBS", "♣", false)
        ]
        let ranks: [(api: String, display: String)] = [
            ("ACE", "A"), ("2", "2"), ("3", "3"), ("4", "4"), ("5", "5"),
            ("6", "6"), ("7", "7"), ("8", "8"), ("9", "9"), ("10", "10"),
            ("JACK", "J"), ("QUEEN", "Q"), ("KING", "K")
        ]

        return suits.flatMap { suit in
            ranks.map { rank in
                DrawnCard(
                    value: rank.display,
                    suit: suit.name,
                    suitSymbol: suit.symbol,
                    isRed: suit.isRed
                )
            }
        }
    }()
}
