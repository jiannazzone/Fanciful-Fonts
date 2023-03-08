//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//  https://www.colourlovers.com/palette/3636765/seapunk_vaporwave

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var userInput = String()
    @State private var outputs = [FancyText]()
    @State private var currentFancyText = "fancy"
    let fancyText = [
        "ⓕⓐⓝⓒⓨ",
        "ｆａｎｃｙ",
        "🄵🄰🄽🄲🅈",
        "🅵🅰🅽🅲🆈",
        "f̶a̶n̶c̶y̶",
        "fancy"
    ]
    @State private var bottomText = "Tap any icon to copy it to your clipboard."
    @State private var showHelpView = false
    
    @FocusState private var inputIsFocused: Bool
    
    var body: some View {
        
        VStack {
            
            // MARK: TITLE
            TitleView()
            
            // MARK: INPUT AREA
            HStack {
                TextField("Type something...", text: $userInput, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(Color("AccentColor"))
                    .font(.title3)
                    .focused($inputIsFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                inputIsFocused = false
                            } // Button
                        } // ToolbarItemGroup
                    } // toolbar
                
                if (userInput != String()) {
                    Button {
                        userInput = String()
                    } label: {
                        Image(systemName: "x.square.fill")
                            .imageScale(.large)
                    } // Button
                    .keyboardShortcut(.cancelAction)
                } // if
            } // HStack
            .padding(.bottom)
            
            // MARK: OUTPUT AREA
            
            if userInput != String() {
                OutputView(outputs: outputs, bottomText: $bottomText)
            } // if
            
            Spacer()
            
            ZStack {
                VStack {
                    if userInput != String() {
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
            .foregroundColor(Color("AccentColor"))
            .frame(maxHeight: 34.0)
            
        } // VStack
        .padding()
        .onChange(of: userInput) { _ in
            outputs = convertText(userInput: userInput)
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
            inputIsFocused = true
        } // onAppear
        .sheet(isPresented: $showHelpView) {
            HelpView()
        }
    } // View
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
