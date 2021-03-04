//
//  MemoryGame.swift
//  Memo
//
//  Created by ehco on 2021/3/2.
//

import Foundation

// Model
struct MemoryGame<CardContent> {
    var cards: Array<Card>
    var indexOfTheOneOnlyFacedUpCard: Int? = nil

    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        if let idx: Int = self.cards.firstIndex(matching: card), !cards[idx].isFaceUp, !cards[idx].isMatched {
            self.cards[idx].isFaceUp = !self.cards[idx].isFaceUp
        }

    }



    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for idx in 0..<numberOfPairsOfCards {
            let content: CardContent = cardContentFactory(idx)
            cards.append(Card(isFaceUp: true, isMatched: false, content: content, id: idx * 2))
            cards.append(Card(isFaceUp: false, isMatched: false, content: content, id: idx * 2 + 1))
        }
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }

}
