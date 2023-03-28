//
//  OutputView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @EnvironmentObject var outputModel: FancyTextModel
    @State var outputPlaceholder = "Your text here"
    var outputIndex = 0;
    @Binding var bottomText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let gradient = [Color("AccentColor"), Color("GradientEnd")]
        
        ScrollView(showsIndicators: false) {
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
                        } // if
                        
                        // Animation
                        withAnimation {
                            bottomText = "Copied to clipboard"
                        } // withAnimation
                        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
                            withAnimation{
                                bottomText = "Tap an icon to copy it to your clipboard."
                            } // withAnimation
                        } // Timer
                    } label: {
                        ZStack {
                            OutputButton(label: outputModel.styledOutput.value == String() ? outputPlaceholder : outputModel.styledOutput.value)
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(
                                    Color("BorderColor"),
                                    lineWidth: 2)
                        } // ZStack
                    } // Button
                    
                    // Clear button
                    if (outputModel.styledOutput.value != outputModel.userInput) {
                        Button {
                            withAnimation {
                                outputModel.clearAllOptions()
                                outputModel.createStylizedText()
                            } // withAnimation
                        } label: {
                            Image(systemName: "eraser.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("AccentColor"))
                        } // Button
                    } // if
                } // HStack
                
                // Bold/Italic/Serif Selectors
                HStack {
                    // Bold Button
                    Button {
                        withAnimation {
                            outputModel.fontStyles["Bold"]!.toggle()
                        } // withAnimation
                    } label: {
                        ZStack {
                            OutputButton(label: "Bold")
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(outputModel.fontStyles["Bold"]! ? .white : .clear, lineWidth: 2)
                        } // ZStack
                    } // Button
                    
                    // Italic Button
                    Button {
                        withAnimation {
                            outputModel.fontStyles["Italic"]!.toggle()
                        } // withAnimation
                    } label: {
                        ZStack {
                            OutputButton(label: "Italic")
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(outputModel.fontStyles["Italic"]! ? .white : .clear, lineWidth: 2)
                        } // ZStack
                    } // Button
                    
                    // Serif Button
                    if outputModel.fontStyles["Italic"]! || outputModel.fontStyles["Bold"]! {
                        Button {
                            outputModel.fontStyles["Serif"]!.toggle()
                        } label: {
                            ZStack {
                                OutputButton(label: "Serif")
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(outputModel.fontStyles["Serif"]! ? .white : .clear, lineWidth: 2)
                            } // ZStack
                        } // Button
                    } // if
                } // HStack
                
                // Diacritic Selectors
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<outputModel.combiningMarks.count, id: \.self) { i in
                            Button {
                                withAnimation {
                                    outputModel.combiningMarks[i].isActive.toggle()
                                }
                            } label: {
                                ZStack {
                                    OutputButton(label: String(outputModel.combiningMarks[i].unicode))
                                        .aspectRatio(1, contentMode: .fit)
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(outputModel.combiningMarks[i].isActive ? .white : .clear, lineWidth: 2)
                                }
                            }
                        }
                    }
                }
                
            }
            .disabled(outputModel.userInput == String())
            
            // MARK: Other Options
            if (outputModel.userInput != String()) {
                Divider()
                    .overlay(LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .padding(.vertical)
                
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
                                ZStack {
                                    OutputButton(label: output.value)
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(
                                            Color("BorderColor"),
                                            lineWidth: 2)
                                }
                                //                                    Text(output.description)
                                //                                        .font(.caption)
                            } // VStack
                        } // Button
                    } // ForEach
                } // LazyVGrid
                //                    .foregroundColor(Color("AccentColor"))
            } // if
            
        } // ScrollView
        .onChange(of: outputModel.userInput) { _ in
            outputModel.createStylizedText()
        }
        .onChange(of: outputModel.fontStyles) { _ in
            outputModel.createStylizedText()
        }
        .onChange(of: outputModel.combiningMarks) { _ in
            outputModel.createStylizedText()
        }
        .onAppear {
            let outputPlaceholderOptions = [
                "Ｙｏｕｒ　ｔｅｘｔ　ｈｅｒｅ",
                "🅈🄾🅄🅁 🅃🄴🅇🅃 🄷🄴🅁🄴",
                "🆈🅾🆄🆁 🆃🅴🆇🆃 🅷🅴🆁🅴",
                "ⓨⓞⓤⓡ ⓣⓔⓧⓣ ⓗⓔⓡⓔ",
                "𝐘𝐨𝐮𝐫 𝐭𝐞𝐱𝐭 𝐡𝐞𝐫𝐞",
                "𝘠𝘰𝘶𝘳 𝘵𝘦𝘹𝘵 𝘩𝘦𝘳𝘦",
                "𝙔𝙤𝙪𝙧 𝙩𝙚𝙭𝙩 𝙝𝙚𝙧𝙚",
                "Your text here"
            ]
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                outputPlaceholder = outputPlaceholderOptions[i]
                if i == outputPlaceholderOptions.count - 1 {
                    i = 0
                } else {
                    i += 1
                } // if-else
            } // Timer
        }
    }
}
