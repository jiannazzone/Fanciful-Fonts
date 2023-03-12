//
//  HelpView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct HelpView: View {
    
    @Environment(\.presentationMode) var presentationValue
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
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

                } // VStack
                .multilineTextAlignment(.leading)
            } // ScrollView
        } // VStack
        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        .padding()
        .background(Color("BackgroundColor"))
    } // View
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
