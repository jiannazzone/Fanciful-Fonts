//
//  OutputButton.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct OutputButton: View {
    let label: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("AccentColor"))
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
