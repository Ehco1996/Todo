//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/30.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore

    var body: some View {
        List {
            ForEach(store.documents) { document in
                Text(self.store.name(for: document))
            }
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
