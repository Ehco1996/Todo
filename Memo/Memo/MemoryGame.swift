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

    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        let idx: Int = self.index(of: card)
        self.cards[idx].isFaceUp = !self.cards[idx].isFaceUp
    }

    func index(of card: Card) -> Int {
        for idx in 0..<cards.count {
            if self.cards[idx].id == card.id {
                return idx
            }
        }
        return -1 // TODO: bug
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
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }

}
