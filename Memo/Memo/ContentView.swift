//
//  ContentView.swift
//  Memo
//
//  Created by ehco on 2021/3/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack { //HStack水平排列，不加HStack的话会显示出四个页面来
            ForEach(0..<4) { i in //四个卡片，0...4包括4，0..<4是0-3
                CardView(isFaceUp: i != 1) //初始值false，不初始化会报错
            }
        }
            .padding() //卡片之间的间距，不设置是为了保持为标准间剧
        .foregroundColor(Color.orange) //属性可以被覆盖
        .font(Font.largeTitle)
    }
}

struct CardView: View {
    var isFaceUp: Bool

    var body: some View {
        ZStack { //本质上是一张卡片
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke()
                Text("X")
            } else {
                //会自动匹配上面的foregroundColor(Color.orange)
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
