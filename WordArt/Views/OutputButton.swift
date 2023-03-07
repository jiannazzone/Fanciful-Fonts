//
//  OutputButton.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputButton: View {
    let label: String
    @State var gradientIndex = 0
    let gradients = [
        [Color("AccentColor"), Color("GradientEnd")],
        [Color("GradientEnd"), Color("AccentColor")]
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    colors: gradients[gradientIndex],
                    startPoint: .leading,
                    endPoint: .trailing))
            Text(label)
                .padding()
                .foregroundColor(.white)
        }
    }
}

struct OutputButton_Previews: PreviewProvider {
    static var previews: some View {
        OutputButton(label: "sample")
    }
}
