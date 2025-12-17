//
//  ContentView.swift
//  WordArt
//
//  Refactored for iOS 17+ - Fixed onChange warning
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var outputModel: FancyTextModel
    @State private var userSettings = UserSettings()
    @State private var activeSheet: SheetType?
    
    @FocusState private var inputIsFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    // Computed property - no state update cascade
    private var bottomText: String {
        outputModel.userInput.isEmpty ? "" : "Tap an icon to copy it to your clipboard."
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if outputModel.isExpanded {
                expandedView
            } else {
                CompactView(outputModel: outputModel)
            }
        }
        .tint(Color("AccentColor"))
        .padding()
        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
        .onAppear {
            outputModel.userInput = ""
            checkForUpdate()
        }
        .sheet(item: $activeSheet) { sheet in
            sheetContent(for: sheet)
        }
    }
    
    // MARK: - Expanded View
    
    @ViewBuilder
    private var expandedView: some View {
        if outputModel.isFullApp {
            TitleView()
        }
        
        inputArea
        
        OutputView(outputModel: outputModel, bottomText: bottomText)
            .scrollDismissesKeyboard(.immediately)
        
        Spacer()
    }
    
    // MARK: - Input Area
    
    private var inputArea: some View {
        HStack {
            TextField("Type anything to begin", text: $outputModel.userInput, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(!userSettings.enableAutocorrect)
                .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
                .font(.title3)
                .focused($inputIsFocused)
                .onChange(of: outputModel.userInput) { _, _ in
                    // Single point of update - tells model to process
                    outputModel.inputDidChange()
                }
            
            if outputModel.userInput.isEmpty {
                helpButton
            } else {
                clearButton
            }
        }
        .padding(.bottom)
    }
    
    private var clearButton: some View {
        Button {
            withAnimation {
                outputModel.clearInput()
                inputIsFocused = true
            }
        } label: {
            Image(systemName: "x.square.fill")
                .imageScale(.large)
                .foregroundColor(Color("AccentColor"))
        }
        .keyboardShortcut(.cancelAction)
    }
    
    private var helpButton: some View {
        Button {
            activeSheet = .help
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .imageScale(.large)
                .padding(.trailing)
        }
    }
    
    // MARK: - Sheet Content
    
    @ViewBuilder
    private func sheetContent(for sheet: SheetType) -> some View {
        switch sheet {
        case .help:
            HelpView(userSettings: userSettings)
            
        case .whatsNew:
            if outputModel.isFullApp {
                WhatsNewView(userSettings: userSettings)
                    .onAppear { inputIsFocused = false }
                    .onDisappear { inputIsFocused = true }
            }
        }
    }
    
    // MARK: - Version Check
    
    private func checkForUpdate() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        
        if userSettings.savedVersion != currentVersion && userSettings.notFirstLaunch && outputModel.isFullApp {
            activeSheet = .whatsNew
        }
        
        userSettings.savedVersion = currentVersion
        userSettings.notFirstLaunch = true
    }
}

// MARK: - Sheet Type

enum SheetType: Identifiable {
    case help
    case whatsNew
    
    var id: Int { hashValue }
}

// MARK: - Preview

#Preview {
    ContentView(outputModel: FancyTextModel(isFullApp: true))
}
