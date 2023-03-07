//
//  HelpBox.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct HelpBox: View {
    let label: String
    let icon: String?
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
            HStack {
                if icon != nil {
                    Image(systemName: icon!)
                        .imageScale(.large)
                }
                Text(label)
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

struct HelpBox_Previews: PreviewProvider {
    static var previews: some View {
        HelpBox(label: "Example", icon: "safari")
    }
}
