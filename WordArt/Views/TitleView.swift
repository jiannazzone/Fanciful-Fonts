//
//  TitleView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        Text("🆆🅾🆁🅳 🅰🆁🆃")
            .font(.system(size: 42))
            .bold()
            .foregroundStyle(
            LinearGradient(
                colors: [Color("AccentColor"), Color("GradientEnd")],
                startPoint: .leading,
                endPoint: .trailing)
            )
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
