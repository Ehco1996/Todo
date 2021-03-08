//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import Foundation


struct EmojiArt {
    var backgroudURL: URL?

    var emojis = [Emoji]()

    struct Emoji: Identifiable {
        let text: String
        var x: Int
        var y: Int
        var size: Int
        let id: Int

        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }

    private var uniqueId = 0

    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueId += 1
        self.emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueId))
    }

}
