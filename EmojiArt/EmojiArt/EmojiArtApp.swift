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
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = EmojiArtDocumentStore(directory: url)
        return WindowGroup {
            EmojiArtDocumentChooser().environmentObject(store)
        }
    }
}
