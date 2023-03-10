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
    @State private var bottomText = ""
    @State private var showHelpView = false
    @State var inputPlaceholder = String()
    
    @FocusState private var inputIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        let gradient = [Color("AccentColor"), Color("GradientEnd")]
        
        VStack (spacing: 10) {
            
            // MARK: TITLE
            if outputModel.isFullApp || (!outputModel.isFullApp && !outputModel.isExpanded){
                TitleView()
            } // if
            
            // MARK: INPUT AREA
            HStack {
                TextField(inputPlaceholder, text: $outputModel.userInput, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
                    .font(.title3)
                    .focused($inputIsFocused)
                    .onTapGesture {
                        if !outputModel.isFullApp {
                            outputModel.isExpanded = true
                            outputModel.expand()
                        }
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
            Section {
                if outputModel.userInput != String() {
                    OutputView(outputModel: outputModel, bottomText: $bottomText)
                } else if outputModel.isFullApp || outputModel.isExpanded {
                        Spacer()
                        VStack {
                            Text("Start typing to get ")
                                .animation(nil)
                            Text(currentFancyText)
                        }
                        .bold()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(LinearGradient(
                                    colors: gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
                        )
                        .foregroundColor(Color("BackgroundColor"))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                } // if-else
            } // Section
            
            Spacer()
            
            // MARK: Notification and Help Button
            if outputModel.isExpanded {
                HStack {
                    Text(bottomText)
                    Spacer()
                    Button {
                        showHelpView = true
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                }
                .onAppear {
                    inputIsFocused = true
                }
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            }
            
        } // VStack
        .tint(Color("AccentColor"))
        .padding()
        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
        .onChange(of: outputModel.userInput) { _ in
            outputModel.convertText(outputModel.userInput)
            if outputModel.userInput != String() {
                bottomText = "Tap an icon to copy it to your clipboard."
            } else {
                bottomText = String()
            } // if-else
        } // onChange
        .onAppear {
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                withAnimation {
                    
                } // withAnimation
                currentFancyText = fancyText[i]
                if i == fancyText.count - 1 {
                    i = 0
                } else {
                    i += 1
                } // if-else
            } // Timer
            if outputModel.isExpanded {
                inputPlaceholder = "Type anything begin"
            } else {
                inputPlaceholder = "Tap to get started"
            }
        } // onAppear
        .sheet(isPresented: $showHelpView) {
            HelpView()
        } // Sheet
    } // View
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(outputModel: FancyTextModel(true))
    }
}
