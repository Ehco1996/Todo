//
//  CircleImage.swift
//  Landmarks
//
//  Created by ehco on 2021/2/3.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("xx"))
    }
}
