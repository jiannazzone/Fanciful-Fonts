//
//  FancyTextModel.swift
//  WordArt
//
//  Refactored for iOS 17+ with debouncing fix
//

import Foundation
import SwiftUI
import Observation

// MARK: - Unicode Offsets

private enum UnicodeOffset {
    static let fullWidth = 65248
    static let fullWidthSpace = 12288
    static let monospaceNumber = 120774
    static let monospaceLower = 120361
    static let monospaceUpper = 120367
    static let scriptLower = 119945
    static let scriptUpper = 119951
    static let circleLower = 9327
    static let circleUpper = 9333
    static let circleNumber = 9263
    static let sharpBoxLower = 127183
    static let sharpBoxUpper = 127215
    static let roundBoxLower = 127247
    static let roundBoxUpper = 127279
    static let parenLower = 9275
    static let parenUpper = 9307
    static let parenNumber = 9283
    static let boldSerifUpper = 119743
    static let boldSerifLower = 119737
    static let boldSerifNumber = 120734
    static let boldSansUpper = 120211
    static let boldSansLower = 120205
    static let boldSansNumber = 120764
    static let italicSerifUpper = 119795
    static let italicSerifLower = 119789
    static let italicSansUpper = 120263
    static let italicSansLower = 120257
    static let boldItalicSerifUpper = 119847
    static let boldItalicSerifLower = 119841
    static let boldItalicSansUpper = 120315
    static let boldItalicSansLower = 120309
    static let triangleEnclosing = 8420
    static let circleSlashEnclosing = 8416
    static let ideographicSpace = 12288
}

// MARK: - Supporting Types

struct FancyText: Identifiable {
    let id = UUID()
    let description: String
    var value: String
    
    init(_ desc: String, value: String = "") {
        self.description = desc
        self.value = value
    }
}

struct CombiningMark: Identifiable, Hashable {
    let id = UUID()
    var isActive = false
    let type: CombiningCategory
    let name: String
    let unicode: UnicodeScalar
    
    init(_ name: String, _ type: CombiningCategory, _ codePoint: Int) {
        self.type = type
        self.name = name
        self.unicode = UnicodeScalar(codePoint) ?? UnicodeScalar(0)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CombiningMark, rhs: CombiningMark) -> Bool {
        lhs.id == rhs.id
    }
}

enum CombiningCategory: String, CaseIterable {
    case over, superscript, through, under
    
    var displayName: String {
        "\(rawValue.capitalized) Marks"
    }
}

// MARK: - Font Style

struct FontStyle: Equatable {
    var bold = false
    var italic = false
    var serif = false
    
    var variant: FontStyleVariant {
        switch (bold, italic, serif) {
        case (true, true, true):
            return .boldItalicSerif
        case (true, true, false):
            return .boldItalicSans
        case (true, false, true):
            return .boldSerif
        case (true, false, false):
            return .boldSans
        case (false, true, true):
            return .italicSerif
        case (false, true, false):
            return .italicSans
        default:
            return .none
        }
    }
    
    var showSerifOption: Bool {
        bold || italic
    }
    
    mutating func clear() {
        bold = false
        italic = false
        serif = false
    }
}

enum FontStyleVariant {
    case boldSerif, boldSans, italicSerif, italicSans
    case boldItalicSerif, boldItalicSans, none
}

// MARK: - Main Model

@Observable
final class FancyTextModel {
    
    // MARK: State
    
    var userInput = ""
    var outputs: [FancyText] = []
    var styledOutput = FancyText("Stylized")
    var finalOutput = ""
    var fontStyle = FontStyle()
    var combiningMarks: [CombiningMark] = CombiningMark.defaults
    
    // MARK: App State
    
    var isFullApp: Bool
    var isExpanded: Bool
    
    // MARK: Messages Extension Callbacks
    
    var expand: (() -> Void)?
    var dismiss: (() -> Void)?
    var insert: (() -> Void)?
    
    // MARK: Private
    
    private var cachedSanitizedInput = ""
    private var cachedUnicodeScalars: [Int] = []
    private var debounceTask: Task<Void, Never>?
    
    // MARK: Initialization
    
    init(isFullApp: Bool) {
        self.isFullApp = isFullApp
        self.isExpanded = isFullApp
    }
    
    // MARK: Public Methods
    
    /// Call this when userInput changes (from TextField binding)
    func inputDidChange() {
        updateCache()
        updateStylizedText()
        debounceSpecialText()
    }
    
    /// Call this when fontStyle or combiningMarks change
    func styleDidChange() {
        guard !userInput.isEmpty else { return }
        updateStylizedText()
    }
    
    func clearAllOptions() {
        fontStyle.clear()
        for i in combiningMarks.indices {
            combiningMarks[i].isActive = false
        }
        updateStylizedText()
    }
    
    func clearInput() {
        userInput = ""
        styledOutput.value = ""
        outputs = []
        clearAllOptions()
    }
    
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        finalOutput = text
        
        // Haptic feedback
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if !isFullApp {
            userInput = ""
            insert?()
        }
    }
    
    // MARK: Private Methods
    
    private func updateCache() {
        cachedSanitizedInput = userInput.applyingTransform(.stripDiacritics, reverse: false) ?? ""
        cachedUnicodeScalars = cachedSanitizedInput.unicodeScalars.map { Int($0.value) }
    }
    
    private func debounceSpecialText() {
        debounceTask?.cancel()
        debounceTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(100))
            guard !Task.isCancelled else { return }
            createSpecialText()
        }
    }
    
    private func updateStylizedText() {
        guard !userInput.isEmpty else {
            styledOutput.value = ""
            return
        }
        
        // Ensure cache is current
        if cachedSanitizedInput.isEmpty {
            updateCache()
        }
        
        // Apply font style transformation
        let baseText: String
        switch fontStyle.variant {
        case .none:
            baseText = userInput
        case .boldSerif:
            baseText = transformText(upper: UnicodeOffset.boldSerifUpper,
                                     lower: UnicodeOffset.boldSerifLower,
                                     number: UnicodeOffset.boldSerifNumber)
        case .boldSans:
            baseText = transformText(upper: UnicodeOffset.boldSansUpper,
                                     lower: UnicodeOffset.boldSansLower,
                                     number: UnicodeOffset.boldSansNumber)
        case .italicSerif:
            baseText = transformItalicSerif()
        case .italicSans:
            baseText = transformText(upper: UnicodeOffset.italicSansUpper,
                                     lower: UnicodeOffset.italicSansLower,
                                     number: nil)
        case .boldItalicSerif:
            baseText = transformText(upper: UnicodeOffset.boldItalicSerifUpper,
                                     lower: UnicodeOffset.boldItalicSerifLower,
                                     number: nil)
        case .boldItalicSans:
            baseText = transformText(upper: UnicodeOffset.boldItalicSansUpper,
                                     lower: UnicodeOffset.boldItalicSansLower,
                                     number: nil)
        }
        
        // Apply combining marks
        styledOutput.value = applyCombiningMarks(to: baseText)
    }
    
    private func transformText(upper: Int, lower: Int, number: Int?) -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isUppercase {
                result += String(UnicodeScalar(num + upper) ?? scalar)
            } else if char.isLowercase {
                result += String(UnicodeScalar(num + lower) ?? scalar)
            } else if char.isNumber, let numberOffset = number {
                result += String(UnicodeScalar(num + numberOffset) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func transformItalicSerif() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char == "h" {
                result += "ℎ"  // Special case: Planck constant
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.italicSerifUpper) ?? scalar)
            } else if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.italicSerifLower) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func applyCombiningMarks(to text: String) -> String {
        let activeMarks = combiningMarks.filter { $0.isActive }
        guard !activeMarks.isEmpty else { return text }
        
        var result = ""
        result.reserveCapacity(text.count * (1 + activeMarks.count))
        
        for char in text {
            result.append(char)
            if char.isLetter || char.isNumber {
                for mark in activeMarks {
                    result.append(Character(mark.unicode))
                }
            }
        }
        return result
    }
    
    private func createSpecialText() {
        guard !userInput.isEmpty else {
            outputs = []
            return
        }
        
        // Define all transformations
        let transforms: [(String, () -> String)] = [
            ("Full Width", fullWidthText),
            ("Monospace", monospaceText),
            ("Flip 180", flip180Text),
            ("Script", scriptText),
            ("Triangle", triangleText),
            ("Circles", circleText),
            ("Circle Slash", circleSlashText),
            ("Boxes", sharpBoxText),
            ("Filled Boxes", roundBoxText),
            ("Parentheses", parenthesizedText),
            ("Sarcastic", spongeText)
        ]
        
        // Update in place if array already sized correctly
        if outputs.count == transforms.count {
            for (index, (_, transform)) in transforms.enumerated() {
                outputs[index].value = transform()
            }
        } else {
            outputs = transforms.map { FancyText($0.0, value: $0.1()) }
        }
    }
    
    // MARK: - Text Transformations
    
    private func fullWidthText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char == " " {
                result += String(UnicodeScalar(UnicodeOffset.fullWidthSpace)!)
            } else if char.isASCII {
                result += String(UnicodeScalar(num + UnicodeOffset.fullWidth) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func monospaceText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isNumber {
                result += String(UnicodeScalar(num + UnicodeOffset.monospaceNumber) ?? scalar)
            } else if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.monospaceLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.monospaceUpper) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func flip180Text() -> String {
        var result = ""
        result.reserveCapacity(cachedSanitizedInput.count)
        
        for char in cachedSanitizedInput.reversed() {
            if let mapped = Self.flip180Map[String(char)] {
                result += String(mapped)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func scriptText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.scriptLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.scriptUpper) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func triangleText() -> String {
        var result = ""
        result.reserveCapacity(userInput.count * 2)
        
        for char in userInput {
            if char == " " {
                result += String(UnicodeScalar(UnicodeOffset.ideographicSpace)!)
            } else if char.isLetter || char.isNumber {
                result += String(char)
                result += String(UnicodeScalar(UnicodeOffset.triangleEnclosing)!)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func circleText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char == "0" {
                result += "⓪"
            } else if char.isNumber {
                result += String(UnicodeScalar(num + UnicodeOffset.circleNumber) ?? scalar)
            } else if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.circleLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.circleUpper) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func circleSlashText() -> String {
        var result = ""
        result.reserveCapacity(userInput.count * 2)
        
        for char in userInput {
            if char == " " {
                result += String(UnicodeScalar(UnicodeOffset.ideographicSpace)!)
            } else if char.isLetter || char.isNumber {
                result += String(char)
                result += String(UnicodeScalar(UnicodeOffset.circleSlashEnclosing)!)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func sharpBoxText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.sharpBoxLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.sharpBoxUpper) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func roundBoxText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.roundBoxLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.roundBoxUpper) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func parenthesizedText() -> String {
        var result = ""
        result.reserveCapacity(cachedUnicodeScalars.count)
        
        for num in cachedUnicodeScalars {
            guard let scalar = UnicodeScalar(num) else { continue }
            let char = Character(scalar)
            
            if char.isLowercase {
                result += String(UnicodeScalar(num + UnicodeOffset.parenLower) ?? scalar)
            } else if char.isUppercase {
                result += String(UnicodeScalar(num + UnicodeOffset.parenUpper) ?? scalar)
            } else if char.isNumber && char != "0" {
                result += String(UnicodeScalar(num + UnicodeOffset.parenNumber) ?? scalar)
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    private func spongeText() -> String {
        var result = ""
        result.reserveCapacity(userInput.count)
        var counter = 0
        
        for char in userInput {
            if counter % 2 == 0 {
                result += char.lowercased()
            } else {
                result += char.uppercased()
            }
            if char.isLetter { counter += 1 }
        }
        return result
    }
    
    // MARK: - Static Data
    
    private static let flip180Map: [String: UnicodeScalar] = [
        "a": "\u{0250}", "b": "q", "c": "\u{0254}", "d": "p",
        "e": "\u{01DD}", "f": "\u{025F}", "g": "\u{0253}", "h": "\u{0265}",
        "i": "\u{0131}", "j": "\u{027E}", "k": "\u{029E}", "l": "\u{006C}",
        "m": "\u{026F}", "n": "u", "o": "o", "p": "d",
        "q": "b", "r": "\u{0279}", "s": "s", "t": "\u{0287}",
        "u": "n", "v": "\u{028C}", "w": "\u{028D}", "x": "x",
        "y": "\u{028E}", "z": "z",
        "A": "\u{2200}", "B": "\u{1660}", "C": "\u{0186}", "D": "\u{15E1}",
        "E": "\u{018E}", "F": "\u{2132}", "G": "\u{2141}", "H": "H",
        "I": "I", "J": "\u{017F}", "K": "\u{22CA}", "L": "\u{02E5}",
        "M": "W", "N": "N", "O": "O", "P": "\u{0500}",
        "Q": "\u{038C}", "R": "\u{1D1A}", "S": "S", "T": "\u{22A5}",
        "U": "\u{2229}", "V": "\u{039B}", "W": "M", "X": "X",
        "Y": "\u{2144}", "Z": "Z",
        "&": "\u{214B}", ".": "\u{02D9}", "\"": "\u{201E}",
        ";": "\u{061B}", "[": "]", "(": ")", "{": "}",
        "?": "\u{00BF}", "!": "\u{00A1}", " ": " "
    ]
}

// MARK: - CombiningMark Defaults

extension CombiningMark {
    static let defaults: [CombiningMark] = [
        // Overmarks
        CombiningMark("carat", .over, 770),
        CombiningMark("tilde", .over, 771),
        CombiningMark("overline", .over, 773),
        CombiningMark("acute accent", .over, 769),
        CombiningMark("diaeresis", .over, 776),
        CombiningMark("hook above", .over, 777),
        CombiningMark("candrabindu", .over, 784),
        CombiningMark("x", .over, 829),
        CombiningMark("vertical tilde", .over, 830),
        CombiningMark("dialytika", .over, 836),
        CombiningMark("almost above", .over, 844),
        CombiningMark("zigzag above", .over, 859),
        
        // Superscript Letters
        CombiningMark("super a", .superscript, 867),
        CombiningMark("super e", .superscript, 868),
        CombiningMark("super i", .superscript, 869),
        CombiningMark("super o", .superscript, 870),
        CombiningMark("super u", .superscript, 871),
        CombiningMark("super c", .superscript, 872),
        CombiningMark("super d", .superscript, 873),
        CombiningMark("super h", .superscript, 874),
        CombiningMark("super m", .superscript, 875),
        CombiningMark("super r", .superscript, 876),
        CombiningMark("super t", .superscript, 877),
        CombiningMark("super v", .superscript, 878),
        CombiningMark("super x", .superscript, 879),
        
        // Throughmarks
        CombiningMark("tilde overlay", .through, 820),
        CombiningMark("strikethrough", .through, 822),
        CombiningMark("slash", .through, 824),
        CombiningMark("reverse solidus overlay", .through, 8421),
        CombiningMark("double vertical overlay", .through, 8422),
        CombiningMark("left arrow overlay", .through, 8426),
        
        // Undermarks
        CombiningMark("ogonek", .under, 808),
        CombiningMark("vertical line below", .under, 809),
        CombiningMark("double arch below", .under, 811),
        CombiningMark("underline", .under, 817),
        CombiningMark("equals below", .under, 839),
        CombiningMark("left-right arrow below", .under, 845),
        CombiningMark("up arrow below", .under, 846),
        CombiningMark("asterisk below", .under, 857),
        CombiningMark("double ring below", .under, 858),
        CombiningMark("right harpoon", .under, 8428),
        CombiningMark("left harpoon", .under, 8429)
    ]
}
