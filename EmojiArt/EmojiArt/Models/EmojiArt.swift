//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import Foundation


struct EmojiArt: Codable {
    var backgroudURL: URL?

    var emojis = [Emoji]()

    struct Emoji: Identifiable, Codable {
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


    var json: Data? {
        return try? JSONEncoder().encode(self)
    }


    // free init 用户手动传所有参数，或者全部用默认值
    init() { }

    // 带个？表示这个init可能会失败，太吊了
    init?(json: Data?) {
        if json != nil, let new = try?JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = new
        } else {

        }
    }
}
