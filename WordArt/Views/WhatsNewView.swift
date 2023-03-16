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
