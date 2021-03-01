//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by ehco on 2021/2/3.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(modelData)
        }
    }
}
