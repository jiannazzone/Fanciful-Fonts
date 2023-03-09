//
//  TitleView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct TitleView: View {
    
    let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        Text("🆆🅾🆁🅳 🅰🆁🆃")
            .font(.system(size: 42))
            .bold()
            .foregroundStyle(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
