//
//  OutputView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let outputModel: FancyTextModel
    @Binding var bottomText: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(outputModel.outputs, id: \.id) { output in
                    Button {
                        // Clipboard and iMessage logic
                        outputModel.finalOutput = output.value
                        UIPasteboard.general.string = output.value
                        if !outputModel.isFullApp {
                            outputModel.userInput = String()
                            outputModel.insert()
                        }
                        
                        // Animation
                        withAnimation {
                            bottomText = "Copied to clipboard"
                        }
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
                            withAnimation{
                                bottomText = "Tap an icon to copy it to your clipboard."
                            }
                        } // Timer
                    } label: {
                        VStack (spacing: 5) {
                            OutputButton(label: output.value)
                            Text(output.description)
                                .font(.caption)
                        } // VStack
                    } // Button
                } // ForEach
            } // LazyVGrid
            .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        } // ScrollView
    }
}
