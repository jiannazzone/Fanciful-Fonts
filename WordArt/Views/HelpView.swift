//
//  HelpView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSettings: UserSettings
    let gradient = [Color("AccentColor"), Color("GradientEnd")]
    @State var showWhatsNew = false
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color("AccentColor"))
                }
            } // HStack
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("🅾🅿🆃🅸🅾🅽🆂")
                        .font(.title)
                        .bold()
                        .foregroundStyle(LinearGradient(
                            colors: gradient,
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading))
                    
                    Button {
                        userSettings.enableAutocorrect.toggle()
                    } label: {
                        HStack {
                            Text("Enable Autocorrect")
                            Spacer()
                            if userSettings.enableAutocorrect {
                                Image(systemName: "checkmark.square")
                            } else {
                                Image(systemName: "square")
                            } // if-else
                        } // HStack
                    } // Button
                    .font(.title3)
                } // VStack
                .foregroundColor(Color("AccentColor"))
                
                Divider()
                    .overlay(LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("🅰🅱🅾🆄🆃")
                        .font(.title)
                        .bold()
                        .foregroundStyle(LinearGradient(
                            colors: gradient,
                            startPoint: .bottomTrailing,
                            endPoint: .topLeading))
                    
                    Section {
                        HelpBox(label: "Unicode is an international standard for encoding letters, characters, and symbols. Its adoption ensures that any device can properly interpret and display symbols from languages all around the world.", icon: nil)
                        Text("🅵🅰🅽🅲🅸🅵🆄🅻 🅵🅾🅽🆃🆂 functions by converting your input into Unicode values, then manipulating those values to create interesting text effects.")
                        
                        Link(destination: URL(string: "https://en.wikipedia.org/wiki/Unicode")!) {
                            HelpBox(label: "Learn more about Unicode", icon: "safari")
                        } // Link
                        
                        Text("Not every combination is available in the Unicode standards. For example, we can create full-width text with any roman characters, but we can only create boxed text with uppercase letters.")
                        
                        HelpBox(label: "Ｆｕｌｌ　Ｗｉｄｔｈ　１２３", icon: nil)
                        HelpBox(label: "🄱🄾🅇🄴🄳 🅃🄴🅇🅃", icon: nil)
                    } // Section
                    
                    Section {
                        Text("We can also manipulate text by adding special Unicode characters after a letter. For example, we can add an underline by using \"Combining Macron Below\" (U+0331) or strikethrough by using \"Combining Long Stroke Overlay\" (U+0336).")
                        
                        HStack {
                            HelpBox(label: "U̱ṉḏe̱ṟḻi̱ṉe̱", icon: nil)
                            Spacer()
                            HelpBox(label: "S̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶", icon: nil)
                        } // HStack
                    } // Section
                    
                    Text("There are many more ways to cusomize text. Expect more to be added in the future!")
                    
                    
                    HelpBox(label: "When working with Unicode, devices and operating systems are able to customize how each character is displayed. This means that when you send text to a friend, it might not look exactly the same as it did on your device, but they'll get the message!", icon: nil)
                    
                    Link(destination: URL(string: "https://github.com/jiannazzone")!) {
                        HelpBox(label: "Check out my other work!", icon: "arrow.down.circle")
                    }
                    
                    Link(destination: URL(string: "mailto:calcuapps@iannaz.zone?subject=Fanciful%20Fonts")!) {
                        HelpBox(label: "Send me an email", icon: "envelope")
                    }
                    
                    Button {
                        showWhatsNew = true
                    } label: {
                        HelpBox(label: "Version \(makeVersionCircle(userSettings.savedVersion))", icon: nil)
                    }
                    
                } // VStack
                .multilineTextAlignment(.leading)
            } // ScrollView
        } // VStack
        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        .padding()
        .background(Color("BackgroundColor"))
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView()
                .environmentObject(userSettings)
        }
    } // View
    
    func makeVersionCircle(_ version: String) -> String {
        var newString = String()
        var stringAsUnicode = [Int]()
        for char in version.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar == "0" {
                newString += "⓪"
            } else if thisChar.isNumber {
                newString += String(UnicodeScalar(num + 9263) ?? UnicodeScalar(0))
            } else {
                newString += String(thisChar)
            }
        }
        
        return newString
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .environmentObject(UserSettings())
    }
}
