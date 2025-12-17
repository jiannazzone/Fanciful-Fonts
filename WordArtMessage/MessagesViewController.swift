//
//  MessagesViewController.swift
//  WordArtMessage
//
//  Refactored for iOS 17+
//

import UIKit
import SwiftUI
import Messages

@objc(MessagesViewController)
class MessagesViewController: MSMessagesAppViewController {
    
    private let outputModel = FancyTextModel(isFullApp: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHostingController()
        setupCallbacks()
    }
    
    // MARK: - Setup
    
    private func setupHostingController() {
        let contentView = ContentView(outputModel: outputModel)
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    private func setupCallbacks() {
        outputModel.expand = { [weak self] in
            self?.requestPresentationStyle(.expanded)
        }
        
        outputModel.insert = { [weak self] in
            guard let self else { return }
            self.activeConversation?.insertText(self.outputModel.finalOutput)
            self.dismiss()
        }
        
        outputModel.dismiss = { [weak self] in
            self?.dismiss()
        }
    }
    
    // MARK: - Presentation Style Transitions
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Prepare for transition
        outputModel.isExpanded = (presentationStyle == .expanded)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Finalize transition
        outputModel.isExpanded = (presentationStyle == .expanded)
    }
    
    // MARK: - Message Handling
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        dismiss()
    }
}
