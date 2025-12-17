//
//  OutputView.swift
//  WordArt
//
//  Refactored for iOS 17+ - Fixed onChange warning and timer leak
//

import SwiftUI

struct OutputView: View {
    
    @Bindable var outputModel: FancyTextModel
    let bottomText: String  // Now passed in, not bound
    
    @State private var outputDisplayText = "Your text here"
    @State private var placeholderTimer: Timer?
    @State private var placeholderIndex = 0
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    private let placeholderOptions = [
        "Ｙｏｕｒ　ｔｅｘｔ　ｈｅｒｅ",
        "🅈🄾🅄🅁 🅃🄴🅇🅃 🄷🄴🅁🄴",
        "🆈🅾🆄🆁 🆃🅴🆇🆃 🅷🅴🆁🅴",
        "ⓨⓞⓤⓡ ⓣⓔⓧⓣ ⓗⓔⓡⓔ",
        "𝐘𝐨𝐮𝐫 𝐭𝐞𝐱𝐭 𝐡𝐞𝐫𝐞",
        "𝘠𝘰𝘶𝘳 𝘵𝘦𝘹𝘵 𝘩𝘦𝘳𝘦",
        "𝙔𝙤𝙪𝙧 𝙩𝙚𝙭𝙩 𝙝𝙚𝙧𝙚",
        "Your text here"
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                stylizedOutputSection
                
                if !outputModel.userInput.isEmpty {
                    otherOptionsSection
                }
            }
        }
        // FIXED: Single task instead of multiple onChange handlers
        .task(id: outputModel.styledOutput.value) {
            updateDisplayText()
        }
        .onAppear {
            startPlaceholderCycling()
        }
        .onDisappear {
            stopPlaceholderCycling()
        }
    }
    
    // MARK: - Display Update
    
    private func updateDisplayText() {
        if outputModel.userInput.isEmpty {
            // Let placeholder cycling handle it
            return
        }
        outputDisplayText = outputModel.styledOutput.value
    }
    
    // MARK: - Stylized Output Section
    
    private var stylizedOutputSection: some View {
        Section {
            // Main output button with clear option
            HStack {
                Button(action: copyStylizedOutput) {
                    ZStack {
                        OutputButton(label: outputDisplayText)
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color("BorderColor"), lineWidth: 2)
                    }
                }
                
                if outputModel.styledOutput.value != outputModel.userInput && !outputModel.userInput.isEmpty {
                    clearStylesButton
                }
            }
            
            gradientDivider
            
            Text("Tap any button below to add font styles")
                .font(.footnote)
                .bold()
                .foregroundColor(Color("AccentColor"))
            
            fontStyleButtons
            combiningMarkRows
        }
    }
    
    private var clearStylesButton: some View {
        Button {
            withAnimation {
                outputModel.clearAllOptions()
            }
        } label: {
            Image(systemName: "eraser.fill")
                .imageScale(.large)
                .foregroundColor(Color("AccentColor"))
        }
    }
    
    // MARK: - Font Style Buttons
    
    private var fontStyleButtons: some View {
        HStack {
            StyleToggleButton(
                label: "Bold",
                isActive: outputModel.fontStyle.bold
            ) {
                withAnimation {
                    outputModel.fontStyle.bold.toggle()
                    outputModel.styleDidChange()
                }
            }
            
            StyleToggleButton(
                label: "Italic",
                isActive: outputModel.fontStyle.italic
            ) {
                withAnimation {
                    outputModel.fontStyle.italic.toggle()
                    outputModel.styleDidChange()
                }
            }
            
            if outputModel.fontStyle.showSerifOption {
                StyleToggleButton(
                    label: "Serif",
                    isActive: outputModel.fontStyle.serif
                ) {
                    outputModel.fontStyle.serif.toggle()
                    outputModel.styleDidChange()
                }
            }
        }
    }
    
    // MARK: - Combining Marks
    
    private var combiningMarkRows: some View {
        VStack {
            ForEach(CombiningCategory.allCases, id: \.self) { category in
                CombiningMarkRow(outputModel: outputModel, category: category)
            }
        }
    }
    
    // MARK: - Other Options Section
    
    private var otherOptionsSection: some View {
        Group {
            gradientDivider
            
            Text("Tap any button below to copy")
                .font(.footnote)
                .bold()
                .foregroundColor(Color("AccentColor"))
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(outputModel.outputs) { output in
                    OutputGridButton(output: output) { text in
                        outputModel.copyToClipboard(text)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private var gradientDivider: some View {
        Divider()
            .overlay(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .padding(.vertical)
    }
    
    // MARK: - Actions
    
    private func copyStylizedOutput() {
        guard !outputModel.styledOutput.value.isEmpty else { return }
        
        let originalText = outputModel.styledOutput.value
        outputModel.copyToClipboard(originalText)
        
        withAnimation {
            outputDisplayText = "Copied to clipboard"
        }
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            await MainActor.run {
                withAnimation {
                    if outputModel.userInput.isEmpty {
                        // Will be handled by placeholder
                    } else {
                        outputDisplayText = outputModel.styledOutput.value
                    }
                }
            }
        }
    }
    
    // MARK: - Timer Management
    
    private func startPlaceholderCycling() {
        placeholderTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            Task { @MainActor in
                guard outputModel.userInput.isEmpty else { return }
                outputDisplayText = placeholderOptions[placeholderIndex]
                placeholderIndex = (placeholderIndex + 1) % placeholderOptions.count
            }
        }
    }
    
    private func stopPlaceholderCycling() {
        placeholderTimer?.invalidate()
        placeholderTimer = nil
    }
}

// MARK: - Style Toggle Button

struct StyleToggleButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                OutputButton(label: label)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isActive ? .white : .clear, lineWidth: 2)
            }
        }
    }
}

// MARK: - Output Grid Button

struct OutputGridButton: View {
    let output: FancyText
    let onCopy: (String) -> Void
    
    @State private var showCopied = false
    
    var body: some View {
        Button {
            onCopy(output.value)
            showCopiedFeedback()
        } label: {
            ZStack {
                OutputButton(label: showCopied ? "Copied" : output.value)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("BorderColor"), lineWidth: 2)
            }
        }
    }
    
    private func showCopiedFeedback() {
        withAnimation {
            showCopied = true
        }
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            await MainActor.run {
                withAnimation {
                    showCopied = false
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    OutputView(
        outputModel: FancyTextModel(isFullApp: true),
        bottomText: ""
    )
}
