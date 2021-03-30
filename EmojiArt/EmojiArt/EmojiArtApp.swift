//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/8.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let sotre = EmojiArtDocumentStore(named: "Emoji Art")
//    sotre.addDocument(named: "1")

    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser(store: EmojiArtDocumentChooser().environmentObject(sotre) as! EnvironmentObject<EmojiArtDocumentStore>)
        }
    }
}
