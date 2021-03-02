//
//  ContentView.swift
//  Memo
//
//  Created by ehco on 2021/3/1.
//

import SwiftUI

struct ContentView: View {

    var viewModel: EmojiMemoryGame


    var body: some View {
        HStack { //HStack水平排列，不加HStack的话会显示出四个页面来
            ForEach(viewModel.cards) { card in
                CardView(card: card)
            }
        }
            .padding() //卡片之间的间距，不设置是为了保持为标准间剧
        .foregroundColor(Color.orange) //属性可以被覆盖
        .font(Font.largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card

    var body: some View {
        ZStack { //本质上是一张卡片
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke()
                Text(card.content)
            } else {
                //会自动匹配上面的foregroundColor(Color.orange)
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: EmojiMemoryGame())
    }
}
