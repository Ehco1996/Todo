//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

struct EmojiArtDocumentView: View {

    private let defaultEmojiSize: CGFloat = 40

    @ObservedObject var document: EmojiArtDocument
    @State private var zoomScale: CGFloat = 1.0


    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    //the map return an array of String
                    //"\"是指key path，"."指this class of things string itself
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString) }
                    }
                }
            }.padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    //绘制drop的image
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                    ).gesture(self.doubleTapToZoom(in: geometry.size))

                    // 绘制drop的emoji
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
                    .clipped()
                    .edgesIgnoringSafeArea([.horizontal, .bottom])
                    .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }


    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
            zoomToFit(self.document.backgroundImage, in: size)
        }
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let yZoom = size.height / image.size.height
            self.zoomScale = min(hZoom, yZoom)
        }
    }

    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize * self.zoomScale)
    }

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * self.zoomScale, y: location.y * self.zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        return location
    }

    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("drop \(url)")
            self.document.setBackgroudYURL(url)
        }

        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        return found

    }


}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
