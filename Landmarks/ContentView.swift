//
//  ContentView.swift
//  Landmarks
//
//  Created by ehco on 2021/2/3.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                Text("景明佳园")
                    .font(.title)

                HStack {
                    Text("雨花台区 铁心桥街道")
                        .font(.subheadline)
                    Spacer()
                    Text("南京市")
                        .font(.subheadline)

                }
                    .font(.subheadline)
                    .foregroundColor(.secondary)


                Divider()
                Text("关于这里")
                    .font(.title2)
                Text("是我家")

            }
                .padding()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
