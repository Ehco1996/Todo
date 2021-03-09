//
//  EmojiDocument.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {

    static let palette: String = "🚗🚕🚙🚌🏎🚓"

    @Published private var emojiArt: EmojiArt = EmojiArt()
    @Published private(set) var backgroundImage: UIImage?

    var emojis: [EmojiArt.Emoji] { return emojiArt.emojis }

    // MARK: - Intent(s)

    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }

    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }


    func setBackgroudYURL(_ url: URL?) {
        emojiArt.backgroudURL = url?.imageURL
        fetchBackgroudImageData()
    }

    func fetchBackgroudImageData() {
        self.backgroundImage = nil
        if let url = self.emojiArt.backgroudURL {
            // 放到后台线程去下载数据
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    // 下载完成之后在放回主线程，接着因为有@Published作为装饰，UI就能知道model发生了变化，并重绘改部分
                    DispatchQueue.main.async {
                        // 防止两个线程互相覆盖数据，我们只保留当前model里需要的url数据
                        if url == self.emojiArt.backgroudURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }

                    }
                }
            }
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
