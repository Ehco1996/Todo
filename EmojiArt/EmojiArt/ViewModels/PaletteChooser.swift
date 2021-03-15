//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/15.
//

import SwiftUI

struct PaletteChooser: View {

    @ObservedObject var document: EmojiArtDocument

    @Binding  var chosenPalette: String

    var body: some View {
        HStack {
            Stepper(
                onIncrement: {
                    self.chosenPalette = self.document.palette(after: self.chosenPalette)
                },
                onDecrement: {
                    self.chosenPalette = self.document.palette(before: self.chosenPalette)
                },
                label: { EmptyView() }
            )
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
        }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false) // 水平方向去掉多余的空间
    }
}

