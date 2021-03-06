//
//  MemoryGame.swift
//  Memo
//
//  Created by ehco on 2021/3/2.
//

import Foundation

// Model
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>

    // 当前面向上方的卡idx
    private var indexOfTheOneOnlyFacedUpCard: Int? {
        get { cards.indices.filter { idx in cards[idx].isFaceUp }.only }
        // 每次设置时，将所有其他card反过来
        set(newIdx) {
            for idx in cards.indices {
                cards[idx].isFaceUp = idx == newIdx
            }
        }
    }

    mutating func choose(card: Card) {
        print("card chosen: \(card)")
        if let idx: Int = self.cards.firstIndex(matching: card), !cards[idx].isFaceUp, !cards[idx].isMatched {
            // 匹配上了
            if let potentialMatchIdx = indexOfTheOneOnlyFacedUpCard {
                if cards[idx].content == cards[potentialMatchIdx].content {
                    cards[idx].isMatched = true
                    cards[potentialMatchIdx].isMatched = true
                    cards[idx].isFaceUp = true
                }
            } else { // 没匹配上，除了选的那张之外，其他卡全部反过来
                indexOfTheOneOnlyFacedUpCard = idx
            }
        }
    }

    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for idx in 0..<numberOfPairsOfCards {
            let content: CardContent = cardContentFactory(idx)
            cards.append(Card(content: content, id: idx * 2))
            cards.append(Card(content: content, id: idx * 2 + 1))
        }
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }

}
