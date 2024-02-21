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
    @State var outputDisplayText = "Your text here"
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
                            outputDisplayText = "Copied to clipboard"
                        } // withAnimation
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
                            withAnimation{
                                outputDisplayText = outputModel.styledOutput.value
                            } // withAnimation
                        } // Timer
                    } label: {
                        ZStack {
                            OutputButton(label: outputDisplayText)
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
                
                // Font Style Buttons
                Divider()
                    .overlay(LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .padding(.vertical)
                
                Text("Tap any button below to add font styles")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color("AccentColor"))
                
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
                VStack {
                    CombiningMarkRow(thisType: .over)
                    CombiningMarkRow(thisType: .superscript)
                    CombiningMarkRow(thisType: .through)
                    CombiningMarkRow(thisType: .under)
                } // VStack
                .environmentObject(outputModel)
                
            }
            
            // MARK: Other Options
            if (outputModel.userInput != String()) {
                Divider()
                    .overlay(LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    .padding(.vertical)
                
                Text("Tap any button below to copy")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color("AccentColor"))
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<outputModel.outputs.count, id: \.self) { i in
                        let thisOutput = outputModel.outputs[i]
                        let thisLabel = thisOutput.value
                        Button {
                            // Clipboard and iMessage logic
                            outputModel.finalOutput = thisOutput.value
                            UIPasteboard.general.string = thisOutput.value
                            if !outputModel.isFullApp {
                                outputModel.userInput = String()
                                outputModel.insert()
                            }
                            
                            // Animation
                            withAnimation {
                                outputModel.outputs[i].value = "Copied"
                            } // withAnimation
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
                                withAnimation{
                                    outputModel.outputs[i].value = thisLabel
                                }
                            } // Timer
                        } label: {
                            VStack (spacing: 5) {
                                ZStack {
                                    OutputButton(label: thisOutput.value)
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(
                                            Color("BorderColor"),
                                            lineWidth: 2)
                                } // ZStack
                            } // VStack
                        } // Button
                    } // ForEach
                } // LazyVGrid
            } // if
            
        } // ScrollView
        .onChange(of: outputModel.userInput) { _ in
            if outputModel.userInput == String() {
                outputDisplayText = "Your Text Here"
            } else {
                outputModel.createStylizedText()
                outputDisplayText = outputModel.styledOutput.value
            }
        }
        .onChange(of: outputModel.fontStyles) { _ in
            if outputModel.userInput != String() {
                outputModel.createStylizedText()
                outputDisplayText = outputModel.styledOutput.value
            }
        }
        .onChange(of: outputModel.combiningMarks) { _ in
            if outputModel.userInput != String() {
                outputModel.createStylizedText()
                outputDisplayText = outputModel.styledOutput.value
            }
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
                if outputModel.userInput == String() {
                    outputDisplayText = outputPlaceholderOptions[i]
                    if i == outputPlaceholderOptions.count - 1 {
                        i = 0
                    } else {
                        i += 1
                    } // if-else
                }
            } // Timer
        }
    }
}
