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
        Grid(self.viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)
            }.padding(5) //卡片之间的间距
        }.padding() // 和屏幕的间距
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

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if self.card.isFaceUp || !self.card.isMatched {
            ZStack {
                Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90), clockkwise: true)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
            }
                .cardify(isFaceUp: card.isFaceUp)
        }
    }


    // MARK: - Drawing Constants
    func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }
    private let fontScaleFactor: CGFloat = 0.7

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
