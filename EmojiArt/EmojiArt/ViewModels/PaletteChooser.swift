//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/15.
//

import SwiftUI

struct PaletteChooser: View {
    var body: some View {
        HStack {
            Stepper(
                onIncrement: /*@START_MENU_TOKEN@*/ { }/*@END_MENU_TOKEN@*/,
                onDecrement: /*@START_MENU_TOKEN@*/ { }/*@END_MENU_TOKEN@*/,
                label: { EmptyView() }
            )
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false) // 垂直方向
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
