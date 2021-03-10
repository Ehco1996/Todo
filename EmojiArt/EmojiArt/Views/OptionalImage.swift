//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by ehco on 2021/3/10.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?

    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}


struct OptionaImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage()
    }
}
