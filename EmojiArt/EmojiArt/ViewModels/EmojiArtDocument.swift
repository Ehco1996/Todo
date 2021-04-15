//
//  EmojiDocument.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable, Equatable {
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }

    let id: UUID
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static let palette: String = "🚗🚕🚙🚌🏎🚓"

    static let untitled = "EmojiArtDocument.Untitled1"

    @Published private var emojiArt: EmojiArt

    private var autosaveCancallable: AnyCancellable?

    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultKey = "EmojiArtDocumentStore.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        autosaveCancallable = $emojiArt.sink { emojiArt in
            print("json=\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: defaultKey)
        }
        fetchBackgroudImageData()
    }

    var url: URL? {
        didSet { self.save(self.emojiArt) }
    }

    init(url: URL) {
        self.id = UUID()
        self.url = url
        self.emojiArt = EmojiArt(json: try? Data(contentsOf: url)) ?? EmojiArt()
        fetchBackgroudImageData()
        autosaveCancallable = $emojiArt.sink { emojiArt in
            self.save(emojiArt)
        }

    }

    private func save(_ emojiArt: EmojiArt) {
        if url != nil {
            try? emojiArt.json?.write(to: url!)
        }

    }


    @Published private(set) var backgroundImage: UIImage?

    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero

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


    var backgroundURL: URL? {
        get {
            emojiArt.backgroudURL
        }
        set {
            emojiArt.backgroudURL = newValue?.imageURL
            fetchBackgroudImageData()
        }
    }


    private var fetchImageCancellable: AnyCancellable?
    func fetchBackgroudImageData() {
        self.backgroundImage = nil
        if let url = self.emojiArt.backgroudURL {
            fetchImageCancellable?.cancel()// 防止并发，每次下载之前取消上一次的下载
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { data, urlresponse in UIImage(data: data) } // publish the result
            .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
