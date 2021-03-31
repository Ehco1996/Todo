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
        let store = EmojiArtDocumentStore(named: "Emoji Art")
        return WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
