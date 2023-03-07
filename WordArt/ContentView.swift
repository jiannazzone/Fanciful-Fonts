//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//  https://www.colourlovers.com/palette/3636765/seapunk_vaporwave

import SwiftUI

struct ContentView: View {
    
    @State private var userInput:String = ""
    @State private var outputs = [FancyText]()
    
    var body: some View {
        
        VStack {
            
            // MARK: TITLE
            Text("🆆🅾🆁🅳 🅰🆁🆃")
                .font(.system(size: 42))
                .foregroundColor(Color("AccentColor"))
                .bold()
            
            // MARK: INPUT AREA
            HStack {
                TextField("Type something...", text: $userInput, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(Color("AccentColor"))
                if (userInput != String()) {
                    Button {
                        userInput = String()
                    } label: {
                        Image(systemName: "x.square")
                            .imageScale(.large)
                    } // Button
                }
            } // HStack
            .padding(.bottom)
            
            // MARK: OUTPUT AREA
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            
            if userInput != String() {
                ScrollView(showsIndicators: false){
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(outputs, id: \.id) { output in
                            Button {
                                UIPasteboard.general.string = output.value
                            } label: {
                                OutputButton(label: output.value)
                            } // Button
                        } // ForEach
                    } // LazyVGrid
                } // ScrollView
            } else {
                Spacer()
                Text("Start typing to get\nｆａｎｃｙ！")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("AccentColor"))
            } // if-else
            
            Spacer()
            if userInput != String() {
                Text("Tap any icon to copy it to your clipboard.")
            } // if
            
        } // VStack
        .padding()
        .onChange(of: userInput) { _ in
            convertText()
        } // onChange
    } // View
    
    func convertText() {
        
        outputs = [FancyText]()
        
        var stringAsUnicode = [Int]()
        for char in userInput.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        // Full-Width Romaji
        var fullWidth = FancyText()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            if thisChar == " " {
                fullWidth.value += "　"
            } else if thisChar == "." {
                fullWidth.value += "．"
            } else {
                fullWidth.value += String(UnicodeScalar(num + 65248) ?? UnicodeScalar(0))
            }
        }
        outputs.append(fullWidth)
        
        // Circle Text
        var circleText = FancyText()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isNumber {
                circleText.value += String(UnicodeScalar(num + 9263) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                circleText.value += String(UnicodeScalar(num + 9327) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                circleText.value += String(UnicodeScalar(num + 9333) ?? UnicodeScalar(0))
            } else {
                circleText.value += String(thisChar)
            }
        }
        outputs.append(circleText)
        
        // Sharp Box Text
        var sharpBox = FancyText()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isLowercase {
                sharpBox.value += String(UnicodeScalar(num + 127183) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                sharpBox.value += String(UnicodeScalar(num + 127215) ?? UnicodeScalar(0))
            } else {
                sharpBox.value += String(thisChar)
            }
        }
        outputs.append(sharpBox)
        
        // Strikethrough Text
        var strikethroughText = FancyText()
        for char in userInput {
            strikethroughText.value += String(char)
            strikethroughText.value += String(UnicodeScalar(822) ?? UnicodeScalar(0))
        }
        outputs.append(strikethroughText)
        
        // Underline Text
        var underlineText = FancyText()
        for char in userInput {
            underlineText.value += String(char)
            underlineText.value += String(UnicodeScalar(817) ?? UnicodeScalar(0))
        }
        outputs.append(underlineText)
        
        // Sponge Text
        var spongeText = FancyText()
        for i in 0..<userInput.count {
            if i % 2 == 0 {
                spongeText.value += userInput[i].lowercased()
            } else {
                spongeText.value += userInput[i].uppercased()
            }
        }
        outputs.append(spongeText)
        
    } // convertText
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
