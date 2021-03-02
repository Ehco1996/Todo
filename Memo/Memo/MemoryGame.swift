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

    func choose(card: Card) {
        print("card chosen: \(card)")
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
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
        var id: Int
    }

}
