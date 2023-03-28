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
        VStack(alignment: .leading, spacing: 5) {
            let heading = String("\(thisType.rawValue) Marks")
            Text(heading.capitalized)
                .font(.footnote)
                .foregroundColor(Color("AccentColor"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<outputModel.combiningMarks.count, id: \.self) { i in
                        if outputModel.combiningMarks[i].type == thisType {
                            Button {
                                withAnimation {
                                    outputModel.combiningMarks[i].isActive.toggle()
                                }
                            } label: {
                                ZStack {
                                    let thisLabel = "a" + String(outputModel.combiningMarks[i].unicode)
                                    OutputButton(label: thisLabel)
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(outputModel.combiningMarks[i].isActive ? .white : .clear, lineWidth: 2)
                                } // ZStack
                                .aspectRatio(1, contentMode: .fit)
                            } // Button
                        } // if
                    } // ForEach
                }
            }
        }
    }
}
