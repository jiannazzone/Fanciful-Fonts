//
//  OutputButton.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputButton: View {
    let label: String
    let gradient = [Color("AccentColor"), Color("GradientEnd")]
    @State var isActive: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let cornerRadius = CGFloat(10.0)
        
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(isActive ? .white : .clear, lineWidth: 2)
            Text(label)
                .padding()
                .foregroundColor(.white)
        }
        .onChange(of: isActive) { _ in
            print(label + ": " + String(isActive))
        }
    }
}

struct OutputButton_Previews: PreviewProvider {
    static var previews: some View {
        OutputButton(label: "sample", isActive: true)
            .padding()
            .frame(maxHeight: 200)
            .background(Color("BackgroundColor"))
    }
}
