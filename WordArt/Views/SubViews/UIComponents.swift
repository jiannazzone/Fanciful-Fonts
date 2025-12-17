//
//  UIComponents.swift
//  WordArt
//
//  Shared UI components - can also be split into separate files
//

import SwiftUI

// MARK: - Title View

struct TitleView: View {
    
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        Text("🅵🅰🅽🅲🅸🅵🆄🅻 🅵🅾🅽🆃🆂")
            .font(.system(size: 42))
            .bold()
            .foregroundStyle(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .multilineTextAlignment(.center)
    }
}

// MARK: - Output Button

struct OutputButton: View {
    
    let label: String
    
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            
            Text(label)
                .padding()
                .foregroundColor(.white)
        }
    }
}

// MARK: - Help Box

struct HelpBox: View {
    
    let label: String
    let icon: String?
    
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            
            HStack {
                if let icon {
                    Image(systemName: icon)
                        .imageScale(.large)
                }
                Text(label)
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

// MARK: - Previews

#Preview("TitleView") {
    TitleView()
        .padding()
        .background(Color("BackgroundColor"))
}

#Preview("OutputButton") {
    OutputButton(label: "Sample Text")
        .padding()
        .frame(maxHeight: 100)
        .background(Color("BackgroundColor"))
}

#Preview("HelpBox") {
    VStack {
        HelpBox(label: "Example with icon", icon: "safari")
        HelpBox(label: "Example without icon", icon: nil)
    }
    .padding()
    .background(Color("BackgroundColor"))
}
