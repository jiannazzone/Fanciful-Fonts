//
//  CompactView.swift
//  WordArt
//
//  Refactored for iOS 17+
//

import SwiftUI

struct CompactView: View {
    
    var outputModel: FancyTextModel
    
    var body: some View {
        VStack {
            TitleView()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                if !outputModel.isFullApp {
                    withAnimation {
                        outputModel.isExpanded = true
                        outputModel.expand?()
                    }
                }
            } label: {
                OutputButton(label: "Tap to get started")
                    .frame(maxHeight: 17)
                    .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
                    .padding(.bottom)
            }
        }
    }
}

#Preview {
    CompactView(outputModel: FancyTextModel(isFullApp: false))
}
