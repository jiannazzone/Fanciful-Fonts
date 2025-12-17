//
//  CombiningMarkRow.swift
//  WordArt
//
//  Refactored for iOS 17+
//

import SwiftUI

struct CombiningMarkRow: View {
    
    @Bindable var outputModel: FancyTextModel
    let category: CombiningCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(category.displayName)
                .font(.footnote)
                .foregroundColor(Color("AccentColor"))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(outputModel.combiningMarks.indices, id: \.self) { index in
                        let mark = outputModel.combiningMarks[index]
                        if mark.type == category {
                            markButton(for: index, mark: mark)
                        }
                    }
                }
            }
        }
    }
    
    private func markButton(for index: Int, mark: CombiningMark) -> some View {
        Button {
            withAnimation {
                outputModel.combiningMarks[index].isActive.toggle()
                outputModel.styleDidChange()
            }
        } label: {
            ZStack {
                OutputButton(label: "x\(mark.unicode)")
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(mark.isActive ? .white : .clear, lineWidth: 2)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

#Preview {
    CombiningMarkRow(
        outputModel: FancyTextModel(isFullApp: true),
        category: .over
    )
    .padding()
    .background(Color("BackgroundColor"))
}
