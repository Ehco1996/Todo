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

    @State var chosenPalette: String = ""

    var body: some View {
        VStack {

            HStack {
                PaletteChooser(document: self.document, chosenPalette: $chosenPalette)

                ScrollView(.horizontal) {
                    HStack {
                        //the map return an array of String
                        //"\"是指key path，"."指this class of things string itself
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: self.defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }.onAppear { self.chosenPalette = self.document.defaultPalette }
            }

            GeometryReader { geometry in
                ZStack {
                    //绘制drop的image
                    Color.white.overlay(
                        OptionalImage(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    // 绘制drop的emoji
                    if self.isLoading {
                        Image(systemName: "dpad").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                        }
                    }
                }
                    .clipped()
                    .gesture(self.panGesture())
                    .gesture(zoomGesture())
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


    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil

    }


    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let yZoom = size.height / image.size.height
            self.steadyStatePanOffset = .zero
            self.steadyStateZoomScale = min(hZoom, yZoom)
        }
    }


    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * self.zoomScale, y: location.y * self.zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + self.panOffset.width, y: location.y + self.panOffset.height)
        return location
    }



    // NOTE: 下面都是所有的手势

    // 双击缩放
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
            withAnimation {
                zoomToFit(self.document.backgroundImage, in: size)
            }
        }
    }


    // 双指拖动缩放
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0 // 这个变量会随着手势的变化而变化，从而达到动态缩放的效果
    var zoomScale: CGFloat { steadyStateZoomScale * gestureZoomScale }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, ourGestrueScaleInOut, transition in
            //ourGestrueScaleInOut这个变量会被手势动作传递回$gestureZoomScale
            // 我们不应该直接修改gestureZoomScale这个变量，而是应该通过手势去做
            ourGestrueScaleInOut = latestGestureScale
        }
            .onEnded { finalGestureScale in
            self.steadyStateZoomScale *= finalGestureScale
        }
    }


    //单指移动的gesture
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize { (steadyStatePanOffset + gesturePanOffset) * zoomScale }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffsetInOut, transition in
            gesturePanOffsetInOut = latestDragGestureValue.translation / self.zoomScale
        }
            .onEnded { finalDragGestureValue in
            self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
        }
    }


    // 拖拽手势
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("drop \(url)")
            self.document.backgroundURL = url
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
