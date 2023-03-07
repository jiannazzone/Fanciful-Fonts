//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userInput:String = ""
    @State private var outputs = [String]()
    
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
                ForEach(outputs, id: \.self) { output in
                    OutputButton(label: output)
                } // ForEach
            } // LazyVGrid
            
            Spacer()
        }
        .padding()
        .onChange(of: userInput) { _ in
            convertText()
        }
    }
    
    func convertText() {
        
        outputs = [String]()
        
        var stringAsUnicode = [Int]()
        for char in userInput.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        // Full-Width Romaji
        var fullWidth = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            if thisChar == " " {
                fullWidth += String(thisChar)
            } else {
                fullWidth += String(UnicodeScalar(num + 65248) ?? UnicodeScalar(0))
            }
        }
        outputs.append(fullWidth)
        
        // Circle Text
        var circleText = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isNumber {
                circleText += String(UnicodeScalar(num + 9263) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                circleText += String(UnicodeScalar(num + 9327) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                circleText += String(UnicodeScalar(num + 9333) ?? UnicodeScalar(0))
            } else {
                circleText += String(thisChar)
            }
        }
        outputs.append(circleText)
        
        // Sharp Box Text
        var sharpBox = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isLowercase {
                sharpBox += String(UnicodeScalar(num + 127183) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                sharpBox += String(UnicodeScalar(num + 127215) ?? UnicodeScalar(0))
            } else {
                sharpBox += String(thisChar)
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
