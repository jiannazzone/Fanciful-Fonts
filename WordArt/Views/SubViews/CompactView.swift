//
//  CompactView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/12/23.
//

import SwiftUI

struct CompactView: View {
    @EnvironmentObject var outputModel: FancyTextModel
    
    var body: some View {
            VStack {
                TitleView()
                    .multilineTextAlignment(.center)
                Spacer()
                Button {
                    if !outputModel.isFullApp {
                        withAnimation {
                            outputModel.isExpanded = true
                            outputModel.expand()
                        } // withAnimation
                    } // if
                } label: {
                    OutputButton(label: "Tap to get started")
                        .frame(maxHeight: 17)
                        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
                } // Button
            } // VStack
    } // View
}

struct CompactView_Previews: PreviewProvider {
    static var previews: some View {
        CompactView()
    }
}
