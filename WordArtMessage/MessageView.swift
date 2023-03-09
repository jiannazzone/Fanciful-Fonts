//
//  MessageView.swift
//  WordArtMessage
//
//  Created by Joseph Adam Iannazzone on 3/8/23.
//

import SwiftUI

struct MessageView: View {
    
    @ObservedObject var observable: MessageViewObservable
    
    var body: some View {
        if observable.isExpanded {
            ContentView(fullApp: false)
        } else {
            VStack {
                TitleView()
                Spacer()
                Button {
                    observable.onButtonPress()
                    observable.isExpanded = true
                } label: {
                    OutputButton(label: "Get Started")
                        .frame(maxHeight: 42)
                }
                Spacer()
            }
            .padding()
        }
    }
}
