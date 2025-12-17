//
//  WordArtApp.swift
//  WordArt
//
//  Refactored for iOS 17+
//

import SwiftUI

@main
struct WordArtApp: App {
    
    // iOS 17: @State for @Observable objects owned by the app
    @State private var outputModel = FancyTextModel(isFullApp: true)
    
    var body: some Scene {
        WindowGroup {
            ContentView(outputModel: outputModel)
        }
    }
}
