//
//  ContentView.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

struct EmojiArtDocumentView: View {

    @ObservableObject var docuument: EmojiArtDocment

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView()
    }
}
