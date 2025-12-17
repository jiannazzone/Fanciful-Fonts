//
//  UserSettings.swift
//  WordArt
//
//  Refactored for iOS 17+ using @Observable
//

import Foundation
import Observation

@Observable
final class UserSettings {
    
    var savedVersion: String {
        didSet {
            UserDefaults.standard.set(savedVersion, forKey: Keys.savedVersion)
        }
    }
    
    var notFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(notFirstLaunch, forKey: Keys.notFirstLaunch)
        }
    }
    
    var enableAutocorrect: Bool {
        didSet {
            UserDefaults.standard.set(enableAutocorrect, forKey: Keys.enableAutocorrect)
        }
    }
    
    private enum Keys {
        static let savedVersion = "savedVersion"
        static let notFirstLaunch = "notFirstLaunch"
        static let enableAutocorrect = "enableAutocorrect"
    }
    
    init() {
        self.savedVersion = UserDefaults.standard.string(forKey: Keys.savedVersion) ?? "1.0"
        self.notFirstLaunch = UserDefaults.standard.bool(forKey: Keys.notFirstLaunch)
        self.enableAutocorrect = UserDefaults.standard.bool(forKey: Keys.enableAutocorrect)
    }
}
