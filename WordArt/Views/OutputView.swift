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

    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(outputModel.outputs, id: \.id) { output in
                    Button {
                        outputModel.finalOutput = output.value
                        UIPasteboard.general.string = output.value
                        withAnimation {
                            bottomText = "Copied to clipboard"
                        }
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
                            withAnimation{
                                bottomText = "Tap any icon to copy it to your clipboard."
                            }
                        } // Timer
                        if !outputModel.isFullApp {
                            outputModel.userInput = String()
                            outputModel.dismiss()
                        }
                    } label: {
                        VStack (spacing: 5){
                            OutputButton(label: output.value)
                            Text(output.description)
                                .font(.caption)
                                .foregroundColor(Color("AccentColor"))
                        }
                    } // Button
                } // ForEach
            } // LazyVGrid
        } // ScrollView
    }
}
