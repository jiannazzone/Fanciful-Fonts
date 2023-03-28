//
//  CombiningMarkRow.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/28/23.
//

import SwiftUI

struct CombiningMarkRow: View {
    
    @EnvironmentObject var outputModel: FancyTextModel
    let thisType: CombiningCategory
    
    var body: some View {
        HStack {
            ForEach(0..<outputModel.combiningMarks.count, id: \.self) { i in
                if outputModel.combiningMarks[i].type == thisType {
                    Button {
                        withAnimation {
                            outputModel.combiningMarks[i].isActive.toggle()
                        }
                    } label: {
                        ZStack {
                            OutputButton(label: String(outputModel.combiningMarks[i].unicode))
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(outputModel.combiningMarks[i].isActive ? .white : .clear, lineWidth: 2)
                        } // ZStack
                        .aspectRatio(1, contentMode: .fit)
                    } // Button
                }
            } // ForEach
            Spacer()
        } // HStack
    }
}
