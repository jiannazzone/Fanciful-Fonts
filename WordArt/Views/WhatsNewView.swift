//
//  WhatsNewView.swift
//  WordArt
//
//  Refactored for iOS 17+
//

import SwiftUI

struct WhatsNewView: View {
    
    var userSettings: UserSettings
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        VStack(spacing: 10) {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    versionSections
                    
                    Text("Thank you for using Fanciful Fonts! If you enjoy it, please consider leaving a review.")
                }
                .multilineTextAlignment(.center)
            }
        }
        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
        .padding()
        .background(Color("BackgroundColor"))
    }
    
    // MARK: - Subviews
    
    private var header: some View {
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
        }
        .foregroundStyle(LinearGradient(
            colors: gradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing))
    }
    
    private var versionSections: some View {
        Group {
            
            // Version 1.4.2
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.⑤", gradient: gradient) {
                HelpBox(label: "Updates across the app for performance.", icon: nil)
                HelpBox(label: "Changes to the compact/Messages logic for better animation and UX.", icon: nil)
            }
            
            // Version 1.4.1
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.④.①", gradient: gradient) {
                HelpBox(label: "Update for iOS 26!", icon: nil)
            }
            
            // Version 1.4
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.④", gradient: gradient) {
                HelpBox(label: "UI adjustments! Hopefully things are a little easier to find.", icon: nil)
                HelpBox(label: "Removed the notification popup on the bottom of the screen. Notifications are now displayed directly on the button that has been tapped.", icon: nil)
            }
            
            // Version 1.3.2
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.③.②", gradient: gradient) {
                HelpBox(label: "Fixed a bug where numbers could be shifted by 1.", icon: nil)
            }
            
            // Version 1.3.1
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.③.①", gradient: gradient) {
                HelpBox(label: "Added ʇxǝʇ pǝddıʃℲ", icon: nil)
                HelpBox(label: "You can now toggle autocorrect. Tap the ? icon next to the input field to access app options.", icon: nil)
                HelpBox(label: "Scrolling down now automatically dismisses the keyboard.", icon: nil)
                HelpBox(label: "Tapping the clear button next to the text input field will automatically refocus on the text field and bring up the keyboard for quicker input.", icon: nil)
                HelpBox(label: "Fixed a bug where the keyboard would appear when app updated, obscuring the changelog.", icon: nil)
            }
            
            // Version 1.3
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.③", gradient: gradient) {
                HelpBox(label: "Added 𝚖𝚘𝚗𝚘𝚜𝚙𝚊𝚌𝚎 text.", icon: nil)
                HelpBox(label: "Added 𝓫𝓸𝓵𝓭 𝓼𝓬𝓻𝓲𝓹𝓽 text.", icon: nil)
                HelpBox(label: "Added t⃤r⃤i⃤a⃤n⃤g⃤l⃤e⃤ enclosed text.", icon: nil)
                HelpBox(label: "Added c⃠i⃠r⃠c⃠l⃠e⃠-s⃠l⃠a⃠s⃠h⃠ enclosed text.", icon: nil)
                HelpBox(label: "Added 5 additional combining marks.", icon: nil)
                HelpBox(label: "The combining marks view is now interactive even without any text input.", icon: nil)
            }
            
            // Version 1.2
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.②", gradient: gradient) {
                HelpBox(label: "Added over 20 new combining marks.", icon: nil)
                HelpBox(label: "Added superscript letter combining marks.", icon: nil)
                HelpBox(label: "With all of the new combining marks, it was getting hard to find the ones that you wanted. They're now separated by category.", icon: nil)
            }
            
            // Version 1.1.2
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.①.②", gradient: gradient) {
                HelpBox(label: "Update 1.1.1 broke the space in ｆｕｌｌ　ｗｉｄｔｈ text. That has been fixed. Sorry!", icon: nil)
            }
            
            // Version 1.1.1
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.①.①", gradient: gradient) {
                HelpBox(label: "Fixed an issue where ｆｕｌｌ　ｗｉｄｔｈ wouldn't properly display punctuation.", icon: nil)
                HelpBox(label: "Full width characters now include digits and punctuation.", icon: nil)
                HelpBox(label: "Combining marks now skip punctuation and spaces for better readability.", icon: nil)
                HelpBox(label: "Added additional combining marks.", icon: nil)
            }
            
            // Version 1.1
            VersionSection(title: "🆅🅴🆁🆂🅸🅾🅽 ①.①", gradient: gradient) {
                HelpBox(label: "A major UI update! Instead of selecting various combinations of bold, combining marks, serif, etc. from a long list, users now toggle each option on/off and see the result in a single location.", icon: nil)
                HelpBox(label: "Added additional diacritic and combining markings. Added parenthetical text as an option.", icon: nil)
            }
        }
    }
}

// MARK: - Version Section

struct VersionSection<Content: View>: View {
    let title: String
    let gradient: [Color]
    @ViewBuilder let content: Content
    
    var body: some View {
        Section {
            Text(title)
                .font(.title)
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading))
            
            content
        }
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    WhatsNewView(userSettings: UserSettings())
}
