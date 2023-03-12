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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let cornerRadius = CGFloat(10.0)
        
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

struct OutputButton_Previews: PreviewProvider {
    static var previews: some View {
        OutputButton(label: "sample")
            .padding()
            .frame(maxHeight: 200)
            .background(Color("BackgroundColor"))
    }
}
