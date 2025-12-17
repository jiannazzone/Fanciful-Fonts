//
//  HelpView.swift
//  WordArt
//
//  Refactored for iOS 17+
//

import SwiftUI

struct HelpView: View {
    
    @Bindable var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var showWhatsNew = false
    
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        VStack(spacing: 10) {
            closeButton
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    optionsSection
                    
                    gradientDivider
                    
                    aboutSection
                }
            }
        }
        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        .padding()
        .background(Color("BackgroundColor"))
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView(userSettings: userSettings)
        }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "x.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color("AccentColor"))
            }
        }
    }
    
    private var optionsSection: some View {
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
                    Image(systemName: userSettings.enableAutocorrect ? "checkmark.square" : "square")
                }
            }
            .font(.title3)
        }
        .foregroundColor(Color("AccentColor"))
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🅰🅱🅾🆄🆃")
                .font(.title)
                .bold()
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading))
            
            unicodeExplanation
            combiningMarksExplanation
            linksSection
        }
        .multilineTextAlignment(.leading)
    }
    
    private var unicodeExplanation: some View {
        Group {
            HelpBox(
                label: "Unicode is an international standard for encoding letters, characters, and symbols. Its adoption ensures that any device can properly interpret and display symbols from languages all around the world.",
                icon: nil
            )
            
            Text("🅵🅰🅽🅲🅸🅵🆄🅻 🅵🅾🅽🆃🆂 functions by converting your input into Unicode values, then manipulating those values to create interesting text effects.")
            
            Link(destination: URL(string: "https://en.wikipedia.org/wiki/Unicode")!) {
                HelpBox(label: "Learn more about Unicode", icon: "safari")
            }
            
            Text("Not every combination is available in the Unicode standards. For example, we can create full-width text with any roman characters, but we can only create boxed text with uppercase letters.")
            
            HelpBox(label: "Ｆｕｌｌ　Ｗｉｄｔｈ　１２３", icon: nil)
            HelpBox(label: "🄱🄾🅇🄴🄳 🅃🄴🅇🅃", icon: nil)
        }
    }
    
    private var combiningMarksExplanation: some View {
        Group {
            Text("We can also manipulate text by adding special Unicode characters after a letter. For example, we can add an underline by using \"Combining Macron Below\" (U+0331) or strikethrough by using \"Combining Long Stroke Overlay\" (U+0336).")
            
            HStack {
                HelpBox(label: "U̱ṉḏe̱ṟḻi̱ṉe̱", icon: nil)
                Spacer()
                HelpBox(label: "S̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶", icon: nil)
            }
            
            Text("There are many more ways to customize text. Expect more to be added in the future!")
            
            HelpBox(
                label: "When working with Unicode, devices and operating systems are able to customize how each character is displayed. This means that when you send text to a friend, it might not look exactly the same as it did on your device, but they'll get the message!",
                icon: nil
            )
        }
    }
    
    private var linksSection: some View {
        Group {
            Link(destination: URL(string: "https://github.com/jiannazzone")!) {
                HelpBox(label: "Check out my other work!", icon: "arrow.down.circle")
            }
            
            Link(destination: URL(string: "mailto:calcuapps@iannaz.zone?subject=Fanciful%20Fonts")!) {
                HelpBox(label: "Send me an email", icon: "envelope")
            }
            
            Button {
                showWhatsNew = true
            } label: {
                HelpBox(label: "Version \(formatVersion(userSettings.savedVersion))", icon: nil)
            }
        }
    }
    
    private var gradientDivider: some View {
        Divider()
            .overlay(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
    }
    
    // MARK: - Helpers
    
    private func formatVersion(_ version: String) -> String {
        var result = ""
        for char in version {
            if char == "0" {
                result += "⓪"
            } else if let digit = char.wholeNumberValue, digit > 0 {
                // Convert digit to circled number (① is U+2460, ② is U+2461, etc.)
                if let scalar = UnicodeScalar(0x2460 + digit - 1) {
                    result += String(scalar)
                } else {
                    result += String(char)
                }
            } else {
                result += String(char)
            }
        }
        return result
    }
}

#Preview {
    HelpView(userSettings: UserSettings())
}
