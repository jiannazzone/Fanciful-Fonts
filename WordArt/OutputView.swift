//
//  OutputView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let outputs: [FancyText]
    @Binding var bottomText: String
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(outputs, id: \.id) { output in
                    Button {
                        UIPasteboard.general.string = output.value
                        withAnimation {
                            bottomText = "Copied to clipboard"
                        }
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
                            withAnimation{
                                bottomText = "Tap any icon to copy it to your clipboard."
                            }
                        } // Timer
                    } label: {
                        OutputButton(label: output.value)
                    } // Button
                } // ForEach
            } // LazyVGrid
        } // ScrollView
    }
}
