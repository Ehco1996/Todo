//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/15.
//

import SwiftUI

struct PaletteChooser: View {

    @ObservedObject var document: EmojiArtDocument

    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false

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
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                self.showPaletteEditor = true
            }
                .popover(isPresented: $showPaletteEditor, content: {
                PaletteEditor(chosenPalette: $chosenPalette, isShowing: self.$showPaletteEditor)
                    .environmentObject(self.document)// 把viewmodel传进去
                .frame(minWidth: 300, minHeight: 500)
            })
        }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: false) // 水平方向去掉多余的空间
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument

    @Binding var chosenPalette: String
    @Binding var isShowing: Bool
    @State private var paletteName = ""
    @State private var emojisToAdd = ""


    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }, label: { Text("Done") })
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: self.$paletteName, onEditingChanged: { begin in
                        if !begin {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                    TextField("Add Emoji", text: self.$emojisToAdd, onEditingChanged: { begin in
                        if !begin {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = "" } })
                }

                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.fontSize))
                            .onTapGesture { self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette) }
                    }.frame(height: self.height)
                }
            }
        }.onAppear {
            self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""
        }
    }

    // MARK - Drawing Constants
    var height: CGFloat {
        CGFloat((self.chosenPalette.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
}
