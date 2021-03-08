//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocment())
        }
    }
}
