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
        
        ScrollView(showsIndicators: false) {
            VStack {
                
                // MARK: Stylized Output
                Section {
                    // Stylized Output and Clear Button
                    HStack {
                        Button {
                            // Clipboard and iMessage logic
                            outputModel.finalOutput = outputModel.styledOutput.value
                            UIPasteboard.general.string = outputModel.styledOutput.value
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
                            OutputButton(label: outputModel.styledOutput.value == String() ? "ⓞⓤⓣⓟⓤⓣ" : outputModel.styledOutput.value)
                        } // Button
                        
                        // Clear button
                        if (outputModel.styledOutput.value != outputModel.userInput) {
                            Button {
                                withAnimation {
                                    for key in outputModel.fontStyles.keys {
                                        outputModel.fontStyles[key] = false
                                    }
                                    for key in outputModel.activeCombiningMarks.keys {
                                        outputModel.activeCombiningMarks[key] = false
                                    }
                                    outputModel.createStylizedText()
                                }
                            } label: {
                                Image(systemName: "eraser.fill")
                                    .imageScale(.large)
                                    .foregroundColor(Color("AccentColor"))
                            }
                            
                        }
                    }
                    
                    // Bold/Italic/Serif Selectors
                    HStack {
                        // Bold Button
                        Button {
                            withAnimation {
                                outputModel.fontStyles["Bold"]!.toggle()
                            }
                        } label: {
                            ZStack {
                                OutputButton(label: "Bold")
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(outputModel.fontStyles["Bold"]! ? .white : .clear, lineWidth: 2)
                            }
                        }
                        
                        // Italic Button
                        Button {
                            withAnimation {
                                outputModel.fontStyles["Italic"]!.toggle()
                            }
                        } label: {
                            ZStack {
                                OutputButton(label: "Italic")
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(outputModel.fontStyles["Italic"]! ? .white : .clear, lineWidth: 2)
                            }
                        }
                        
                        // Serif Button
                        if outputModel.fontStyles["Italic"]! || outputModel.fontStyles["Bold"]! {
                            Button {
                                outputModel.fontStyles["Serif"]!.toggle()
                            } label: {
                                ZStack {
                                    OutputButton(label: "Serif")
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(outputModel.fontStyles["Serif"]! ? .white : .clear, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                .disabled(outputModel.userInput == String())
                
                // Diacritic Selectors
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(Array(outputModel.combiningMarkDict.keys), id: \.self) { key in
                            Button {
                                withAnimation {
                                    outputModel.activeCombiningMarks[key]!.toggle()
                                }
                            } label: {
                                ZStack {
                                    OutputButton(label: String(outputModel.combiningMarkDict[key] ?? UnicodeScalar(0)))
                                        .aspectRatio(1, contentMode: .fit)
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(outputModel.activeCombiningMarks[key]! ? .white : .clear, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .onChange(of: outputModel.userInput) { _ in
            outputModel.createStylizedText()
        }
        .onChange(of: outputModel.fontStyles) { _ in
            outputModel.createStylizedText()
        }
        .onChange(of: outputModel.activeCombiningMarks) { _ in
            outputModel.createStylizedText()
        }
        
        
        /*
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
         */
    }
}
