//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//  https://www.colourlovers.com/palette/3636765/seapunk_vaporwave

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var outputModel: FancyTextModel
    @State private var currentFancyText = "fancy"
    let fancyText = [
        "ⓕⓐⓝⓒⓨ",
        "ｆａｎｃｙ",
        "🄵🄰🄽🄲🅈",
        "🅵🅰🅽🅲🆈",
        "f̶a̶n̶c̶y̶",
        "fancy"
    ]
    @State private var bottomText = "Tap any button to copy."
    @State private var showHelpView = false
    
    @FocusState private var inputIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        let gradient = [Color("AccentColor"), Color("GradientEnd")]
        
        VStack (spacing: 10) {
            
            // MARK: TITLE
            if outputModel.isFullApp || (!outputModel.isFullApp && !outputModel.isExpanded){
                TitleView()
            }
            
            if outputModel.isExpanded {
                // MARK: INPUT AREA
                HStack {
                    TextField("Type something...", text: $outputModel.userInput, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
                        .font(.title3)
                        .focused($inputIsFocused)
                        .onAppear {
                            inputIsFocused = true
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    inputIsFocused = false
                                } // Button
                            } // ToolbarItemGroup
                        } // toolbar
                    
                    // Clear Button
                    if (outputModel.userInput != String()) {
                        Button {
                            outputModel.userInput = String()
                        } label: {
                            Image(systemName: "x.square.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("AccentColor"))
                        } // Button
                        .keyboardShortcut(.cancelAction)
                    } // if
                } // HStack
                .padding(.bottom)
                
                // MARK: OUTPUT AREA
                if outputModel.userInput != String() {
                    OutputView(outputModel: outputModel, bottomText: $bottomText)
                } // if
                
                Spacer()
                
                // MARK: Footer and Help Button
                ZStack {
                    VStack {
                        if outputModel.userInput != String() {
                            Text(bottomText)
                        } else {
                            Text("Start typing to get ")
                                .animation(nil)
                            Text(currentFancyText)
                        } // if-else
                    } // VStack
                    
                    HStack {
                        Spacer()
                        Button {
                            showHelpView = true
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .imageScale(.large)
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))

            } else {
                Button {
                    outputModel.expand()
                    outputModel.isExpanded = true
                    inputIsFocused = true
                } label: {
                    OutputButton(label: "Tap to get \(currentFancyText)")
                        .frame(maxHeight: 42)
                }
                .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
            }
            
        } // VStack
        .tint(Color("AccentColor"))
        .padding()
        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
        .transition(.slide)
        .onChange(of: outputModel.userInput) { _ in
            outputModel.convertText(outputModel.userInput)
        } // onChange
        .onAppear {
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                withAnimation {
                    currentFancyText = fancyText[i]
                } // withAnimation
                if i == fancyText.count - 1 {
                    i = 0
                } else {
                    i += 1
                } // if-else
            } // Timer
        } // onAppear
        .sheet(isPresented: $showHelpView) {
            HelpView()
        }
    } // View
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(outputModel: FancyTextModel(true))
    }
}
