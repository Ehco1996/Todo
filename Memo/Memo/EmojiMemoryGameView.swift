//
//  EmojiMemoryGameView.swift
//  Memo
//
//  Created by ehco on 2021/3/1.
//

import SwiftUI

struct EmojiMemoryGameView: View {

    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        HStack { //HStack水平排列，不加HStack的话会显示出四个页面来
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }.padding() //卡片之间的间距，不设置是为了保持为标准间剧
        .foregroundColor(Color.orange) //属性可以被覆盖
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    func body(for size: CGSize) -> some View {
        ZStack { //本质上是一张卡片
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                //会自动匹配上面的foregroundColor(Color.orange)
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }.font(Font.system(size:fontSize(for: size)))
    }

    func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }


    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
