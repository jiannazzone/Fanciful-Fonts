//
//  WhatsNewView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/12/23.
//

import SwiftUI

struct WhatsNewView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            HStack {
                Text("🆆🅷🅰🆃🆂 🅽🅴🆆")
                    .font(.system(size: 42))
                    .bold()
                    .foregroundStyle(LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .imageScale(.large)
                }
            } // HStack
            .foregroundStyle(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Version 1.3.1
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.③.①")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "Added ʇxǝʇ pǝddılɟ", icon: nil)
                        HelpBox(label: "You can now toggle autocorrect. Tap the ? icon next to the input field to access app options.", icon: nil)
                        HelpBox(label: "Scrolling down now automatically dismisses the keyboard.", icon: nil)
                        HelpBox(label: "Tapping the clear button next to the text input field will automatically refocus on the text field and bring up the keyboard for quicker input.", icon: nil)
                    }
                    
                    // Version 1.3
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.③")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "Added 𝚖𝚘𝚗𝚘𝚜𝚙𝚊𝚌𝚎 text.", icon: nil)
                        HelpBox(label: "Added 𝓫𝓸𝓵𝓭 𝓼𝓬𝓻𝓲𝓹𝓽 text.", icon: nil)
                        HelpBox(label: "Added t⃤r⃤i⃤a⃤n⃤g⃤l⃤e⃤ enclosed text.", icon: nil)
                        HelpBox(label: "Added c⃠i⃠r⃠c⃠l⃠e⃠-s⃠l⃠a⃠s⃠h⃠ enclosed text.", icon: nil)
                        HelpBox(label: "Added 5 additional combining marks.", icon: nil)
                        HelpBox(label: "The combining marks view is now interactive even without any text input.", icon: nil)
                    }
                    
                    // Version 1.2
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.②")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "Added over 20 new combining marks.", icon: nil)
                        HelpBox(label: "Added superscript letter combining marks.", icon: nil)
                        HelpBox(label: "With all of the new combining marks, it was getting hard to find the ones that you wanted. They're now separated by category.", icon: nil)
                    }
                    
                    // Version 1.1.2
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.①.②")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "Update 1.1.1 broke the space in ｆｕｌｌ　ｗｉｄｔｈ text. That has been fixed. Sorry!", icon: nil)
                    }
                    
                    // Version 1.1.1
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.①.①")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "Fixed an issue where ｆｕｌｌ　ｗｉｄｔｈ wouldn't properly display punctuation.", icon: nil)
                        HelpBox(label: "Full width characters now include digits and punctuation.", icon: nil)
                        HelpBox(label: "Combining marks now skip punctuation and spaces for better readability.", icon: nil)
                        HelpBox(label: "Added additional combining marks.", icon: nil)
                    }
                    .multilineTextAlignment(.leading)
                    
                    // Version 1.1
                    Section {
                        Text("🆅🅴🆁🆂🅸🅾🅽 ①.①")
                            .font(.title)
                            .foregroundStyle(LinearGradient(
                                colors: gradient,
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading))
                        HelpBox(label: "A major UI update! Instead of selecting various combinations of bold, combining marks, serif, etc. from a long list, users now toggle each option on/off and see the result in a single location.", icon: nil)
                        HelpBox(label: "Added additional diacritic and combining markings. Added parenthetical text as an option.", icon: nil)
                    }
                    .multilineTextAlignment(.leading)
                    
                    Text("Thank you for using Fanciful Fonts! If you enjoy it, please consider leaving a review.")

                } // VStack
                .multilineTextAlignment(.center)

            } // ScrollView
        } // VStack
        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        .padding()
        .background(Color("BackgroundColor"))
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}
