//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//  https://www.colourlovers.com/palette/3636765/seapunk_vaporwave

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var outputModel: FancyTextModel
    var userSettings = UserSettings()
    @State private var showSheet: sheetEnum?

    @State private var currentFancyText = "fancy"
    @State private var bottomText = ""
    @State var inputPlaceholder = String()
    
    @FocusState private var inputIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        let gradient = [Color("AccentColor"), Color("GradientEnd")]
        
        VStack (spacing: 10) {
            
            // MARK: TITLE
            if outputModel.isFullApp || (!outputModel.isFullApp && !outputModel.isExpanded){
                TitleView()
            } // if
            
            // MARK: INPUT AREA
            HStack {
                TextField(inputPlaceholder, text: $outputModel.userInput, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
                    .font(.title3)
                    .focused($inputIsFocused)
                    .onTapGesture {
                        if !outputModel.isFullApp {
                            outputModel.isExpanded = true
                            outputModel.expand()
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                inputIsFocused = false
                            } // Button
                        } // ToolbarItemGroup
                    } // toolbar
                
                // Clear Button
                if (outputModel.userInput != String()) {
                    Button {
                        withAnimation {
                            outputModel.userInput = String()
                            outputModel.clearAllOptions()
                        }
                    } label: {
                        Image(systemName: "x.square.fill")
                            .imageScale(.large)
                            .foregroundColor(Color("AccentColor"))
                    } // Button
                    .keyboardShortcut(.cancelAction)
                } // if
            } // HStack
            .padding(.bottom)
            
            // MARK: OUTPUT AREA
            if outputModel.isExpanded {
                OutputView(outputModel: outputModel, bottomText: $bottomText)
            } // if
            
            Spacer()
            
            // MARK: Notification and Help Button
            if outputModel.userInput != String() {
                HStack {
                    ZStack {
                        OutputButton(label: bottomText)
                            .font(.caption)
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(
                                Color("BorderColor"),
                                lineWidth: 2)
                    } // ZStack
                    Spacer()
                    Button {
                        showSheet = .helpSheet
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                    } // Button
                } // HStack
                .frame(maxHeight: 42)
                .onAppear {
                    inputIsFocused = true
                } // onAppear
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            }
            
        } // VStack
        .tint(Color("AccentColor"))
        .padding()
        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
        .onChange(of: outputModel.userInput) { _ in
            outputModel.createSpecialText(outputModel.userInput)
            if outputModel.userInput != String() {
                bottomText = "Tap an icon to copy it to your clipboard."
            } else {
                bottomText = String()
            } // if-else
        } // onChange
        .onAppear {
            outputModel.userInput = String()
            checkForUpdate()
            if outputModel.isExpanded {
                inputPlaceholder = "Type anything begin"
            } else {
                inputPlaceholder = "Tap to get started"
            }
        } // onAppear
        .sheet(item: $showSheet) { item in
            switch item {
            case .helpSheet:
                HelpView()
            case .whatsNewSheet:
                if outputModel.isFullApp {
                    WhatsNewView()
                } // if
            } // switch
        } // sheet
        
    } // View
    
    // Get current version of the app bundle
    func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        return version
    }
    
    // Check if app if app has been started after update
    func checkForUpdate() {
        let version = getCurrentAppVersion()
        let savedVersion = UserDefaults.standard.string(forKey: "savedVersion")
        print(savedVersion ?? "Error")
        if savedVersion != version  && self.userSettings.notFirstLaunch {
            // Toogle to show WhatsNew Screen as Modal
            inputIsFocused = false
            showSheet = .whatsNewSheet
        } else {
            inputIsFocused = true
        }
        
        UserDefaults.standard.set(version, forKey: "savedVersion")
        self.userSettings.notFirstLaunch = true
    }
    
    enum sheetEnum: Identifiable {
        case helpSheet, whatsNewSheet
        var id: Int {
            hashValue
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(outputModel: FancyTextModel(true))
    }
}
