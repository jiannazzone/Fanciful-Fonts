//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userInput:String = ""
    @State private var outputs = [FancyText]()
    
    var body: some View {
        
        VStack {
            Text("Word Art")
                .font(.largeTitle)
            
            HStack {
                TextField("Type something...", text: $userInput)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                Button {
                    userInput = String()
                } label: {
                    Image(systemName: "x.square")
                        .imageScale(.large)
                }
            } // HStack
            .padding(.bottom)
            
            let columns = [GridItem(.flexible()), GridItem(.flexible())]

            LazyVGrid(columns: columns, spacing: 20) {
                if userInput != String() {
                    ForEach(outputs, id: \.id) { output in
                        OutputButton(label: output.value)
                    } // ForEach
                } else {
                    Text("Start typing to generate fancy text!")
                }
            } // LazyVGrid
            
            Spacer()
        }
        .padding()
        .onChange(of: userInput) { _ in
            convertText()
        }
    }
    
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
                fullWidth.value += String(thisChar)
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
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
