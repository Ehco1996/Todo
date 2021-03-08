//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

struct EmojiArtDocumentView: View {

    @ObservedObject var document: EmojiArtDocment

    var body: some View {


        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach (EmojiArtDocment.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: defaultEmojiSise))
                    }
                }
            }.padding(.horizontal)

            Rectangle()
                .foregroundColor(.yellow)
                .edgesIgnoringSafeArea([.horizontal, .bottom])


        }



    }

    private let defaultEmojiSise: CGFloat = 40
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocment())
    }
}
