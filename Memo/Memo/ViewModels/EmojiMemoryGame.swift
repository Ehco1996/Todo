//
//  EmojiMemoryGame.swift
//  Memo
//
//  Created by ehco on 2021/3/2.
//

import SwiftUI




// ViewModel
class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String> = createMemoryGame()

    // create model
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["😁", "😜", "😇"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { idx in
            return emojis[idx]
        }
    }

    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }

    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }

}
