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
        VStack {
            Grid(self.viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(Animation.linear) {
                        self.viewModel.choose(card: card)
                    }
                }.padding(5) //卡片之间的间距
            }.padding() // 和屏幕的间距
            .foregroundColor(Color.orange) //属性可以被覆盖

            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: {
                    Text("New Game")
                })
        }
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }


    @State private var animateBonusReamining: Double = 0

    private func startBonusTimeAnimation() {
        animateBonusReamining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusRemaining)) {
            animateBonusReamining = 0
        }
    }

    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if self.card.isFaceUp || !self.card.isMatched {
            ZStack {

                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-animateBonusReamining * 360 - 90), clockwise: true).onAppear { self.startBonusTimeAnimation() }
                    } else {
                        //matched的时候，不需要计时了但是还是要pie的，但不需要动画
                        Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                    }
                }.padding(5).opacity(0.4).transition(.identity) //匹配时emoji旋转

                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
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
