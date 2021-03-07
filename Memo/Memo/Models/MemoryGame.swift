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
                }
                cards[idx].isFaceUp = true
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
        cards.shuffle()
    }

    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int

        //直接提供的代码
        // MARK: - Bouns Tims
        // this could give matcing bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        //can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        //how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up(and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in past
        // (i.e not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left befor the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
