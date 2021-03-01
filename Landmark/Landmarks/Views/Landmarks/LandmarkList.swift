//
//  LandmarkList.swift
//  Landmarks
//
//  Created by ehco on 2021/2/4.
//

import SwiftUI

struct LandmarkList: View {

    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false

    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("仅显示收藏")
                }

                ForEach(filteredLandmarks) { landmark in
                    NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
                        LandmarkRow(landmark: landmark)
                    }
                }

            }
                .navigationTitle("Landmarks")
        }
    }
}



struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}
