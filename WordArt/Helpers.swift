//
//  Helpers.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import Foundation
import SwiftUI

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

struct FancyText: Identifiable {
    let id = UUID()
    let description: String
    var value = String()
    
    init (_ desc: String) {
        description = desc
    }
}

struct CombiningMark: Identifiable, Hashable {
    let id = UUID()
    var isActive = false
    
    let type: CombiningCategory
    let name: String
    let unicode: UnicodeScalar
    
    init (_ tempName: String, _ tempType: CombiningCategory, _ tempUnicode: Int) {
        type = tempType
        name = tempName
        unicode = UnicodeScalar(tempUnicode) ?? UnicodeScalar(0)
    }
    
    enum CombiningCategory {
        case under, over, through
    }
}

class FancyTextModel: ObservableObject {
    @Published var userInput = String()
    @Published var outputs = [FancyText]()
    @Published var styledOutput = FancyText("Stylized")
    @Published var finalOutput = String()
    
    // Diacritics
    @Published var combiningMarks: [CombiningMark] = [
        CombiningMark("overline", .over, 773),
        CombiningMark("tilde", .over, 771),
        CombiningMark("x", .over, 829),
        CombiningMark("carat", .over, 770),
        CombiningMark("acute accent", .over, 769),
        CombiningMark("candrabindu", .over, 784),
        CombiningMark("vertical tilde", .over, 830),
        CombiningMark("almost above", .over, 844),
        CombiningMark("strikethrough", .through, 822),
        CombiningMark("slash", .through, 824),
        CombiningMark("tilde overlay", .through, 820),
        CombiningMark("double arch below", .under, 811),
        CombiningMark("underline", .under, 817)
    ]
    
    // Styles
    @Published var fontStyles: [String:Bool] = [
        "Serif": false,
        "Bold": false,
        "Italic": false
    ]
    @Published var activeFontStyle: BoldItalicSerif = .none
    
    // App Logic
    @Published var isFullApp: Bool
    @Published var isExpanded: Bool
    var expand: (() -> Void)!
    var dismiss: (() -> Void)!
    var insert: (() -> Void)!
    
    init(_ val: Bool) {
        isFullApp = val
        isExpanded = val
    }
    
    enum BoldItalicSerif {
        case boldSerif, boldSans, italicSerif, italicSans, boldItalicSerif, boldItalicSans, none
    }
    
    private func updateActiveFontStyle() -> BoldItalicSerif {
        let serifVal = fontStyles["Serif"]!
        let boldVal = fontStyles["Bold"]!
        let italicVal = fontStyles["Italic"]!
        
        // All options on
        if (serifVal && boldVal && italicVal) {
            return .boldItalicSerif
        }
        
        // Serif Options
        if serifVal {
            if boldVal && italicVal {
                return .boldItalicSerif
            }
            if boldVal && !italicVal {
                return .boldSerif
            }
            if !boldVal && italicVal {
                return .italicSerif
            }
        } else {
            if boldVal && italicVal {
                return .boldItalicSans
            }
            if boldVal && !italicVal {
                return .boldSans
            }
            if !boldVal && italicVal {
                return .italicSans
            }
        } // if-else
        
        // All Options Off --> Sans Plain
        return .none
    }
    
    func clearAllOptions() {
        for key in fontStyles.keys {
            fontStyles[key] = false
        }
        
        for i in 0..<combiningMarks.count {
            combiningMarks[i].isActive = false
        }
    }
    
    func createStylizedText() {
        
        activeFontStyle = updateActiveFontStyle()
        
        let sanitizedInput = userInput.applyingTransform(.stripDiacritics, reverse: false) ?? ""
        
        var stringAsUnicode = [Int]()
        for char in sanitizedInput.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        // Apply bold, italic, serif
        
        switch activeFontStyle {
        case .none:
            styledOutput.value = userInput
        case .boldSerif:
            styledOutput.value = boldSerif(stringAsUnicode)
        case .boldSans:
            styledOutput.value = boldSans(stringAsUnicode)
        case .italicSerif:
            styledOutput.value = italicSerif(stringAsUnicode)
        case .italicSans:
            styledOutput.value = italicSans(stringAsUnicode)
        case .boldItalicSerif:
            styledOutput.value = boldItalicSerif(stringAsUnicode)
        case .boldItalicSans:
            styledOutput.value = boldItalicSans(stringAsUnicode)
        } // switch
        
        // Apply combining marks
        var newText = String()
        for char in styledOutput.value {
            newText.append(char)
            if char.isNumber || char.isLetter {
                for mark in combiningMarks {
                    if mark.isActive {
                        newText.append(String(mark.unicode))
                    }
                }
            }
        }
        styledOutput.value = newText
        
    } // createStylizedText
    
    func createSpecialText(_ userInput: String) {
        
        outputs = [FancyText]()
        
        let sanitizedInput = userInput.applyingTransform(.stripDiacritics, reverse: false) ?? ""
        
        var stringAsUnicode = [Int]()
        for char in sanitizedInput.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        // MARK: Specialized Text
        
        // Full-Width Romaji
        let fullWidthText = fullWidth(stringAsUnicode)
        outputs.append(fullWidthText)
        
        // Circle Text
        let circleText = circleText(stringAsUnicode)
        outputs.append(circleText)
        
        // Sharp Box Text
        let sharpBox = sharpBoxText(stringAsUnicode)
        outputs.append(sharpBox)
        
        // Round Box Text
        let roundBoxText = roundBoxText(stringAsUnicode)
        outputs.append(roundBoxText)
        
        // Parenthetical Text
        let parentheses = parenthesizedText(stringAsUnicode)
        outputs.append(parentheses)
        
        // Sponge Text
        let spongeText = spongeText(userInput)
        outputs.append(spongeText)
        
    } // convertText
    
    // MARK: Fancy Text Methods
    
    private func fullWidth(_ stringAsUnicode: [Int]) -> FancyText {
        // Full-Width Romaji
        var fullWidth = FancyText("Full Width")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            if thisChar == " " {
                fullWidth.value += String(UnicodeScalar(12288) ?? UnicodeScalar(0))
            } else if thisChar.isASCII {
                fullWidth.value += String(UnicodeScalar(num + 65248) ?? UnicodeScalar(0))
            } else {
                fullWidth.value += String(thisChar)
            }// if-else
        } // for
        return fullWidth
    } // fullWidth
    
    private func circleText(_ stringAsUnicode: [Int]) -> FancyText {
        var circleText = FancyText("Circles")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar == "0" {
                circleText.value += "⓪"
            } else if thisChar.isNumber {
                circleText.value += String(UnicodeScalar(num + 9263) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                circleText.value += String(UnicodeScalar(num + 9327) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                circleText.value += String(UnicodeScalar(num + 9333) ?? UnicodeScalar(0))
            } else {
                circleText.value += String(thisChar)
            } // if-else
        } // for
        return circleText
    } // circleText
    
    private func sharpBoxText(_ stringAsUnicode: [Int]) -> FancyText {
        var sharpBox = FancyText("Boxes")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isLowercase {
                sharpBox.value += String(UnicodeScalar(num + 127183) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                sharpBox.value += String(UnicodeScalar(num + 127215) ?? UnicodeScalar(0))
            } else {
                sharpBox.value += String(thisChar)
            } // if-else
        } // for
        return sharpBox
    } // sharpBoxText
    
    private func roundBoxText(_ stringAsUnicode: [Int]) -> FancyText {
        var roundBoxText = FancyText("Filled Boxes")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isLowercase {
                roundBoxText.value += String(UnicodeScalar(num + 127247) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                roundBoxText.value += String(UnicodeScalar(num + 127279) ?? UnicodeScalar(0))
            } else {
                roundBoxText.value += String(thisChar)
            } // if-else
        } // for
        return roundBoxText
    } // roundBoxText
    
    private func parenthesizedText(_ stringAsUnicode: [Int]) -> FancyText {
        var parenthsizedText = FancyText("Parentheses")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isLowercase {
                parenthsizedText.value += String(UnicodeScalar(num + 9275) ?? UnicodeScalar(0))
            } else if thisChar.isUppercase {
                parenthsizedText.value += String(UnicodeScalar(num + 9307) ?? UnicodeScalar(0))
            } else if thisChar.isNumber {
                parenthsizedText.value += String(UnicodeScalar(num + 9283) ?? UnicodeScalar(0))
            } else {
                parenthsizedText.value += String(thisChar)
            } // if-else
        } // for
        return parenthsizedText
    }
    
    private func spongeText(_ userInput: String) -> FancyText {
        var spongeText = FancyText("Sarcastic")
        var spongeCounter = 0
        for char in userInput {
            if spongeCounter % 2 == 0 {
                spongeText.value += char.lowercased()
            } else {
                spongeText.value += char.uppercased()
            } // if-else
            if char.isLetter { spongeCounter += 1 } // if
        } // for
        return spongeText
    } // spongeText
    
    private func boldSerif(_ stringAsUnicode: [Int]) -> String {
        var boldTextSerif = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            if thisChar.isUppercase {
                boldTextSerif += String(UnicodeScalar(num + 119743) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldTextSerif += String(UnicodeScalar(num + 119737) ?? UnicodeScalar(0))
            } else {
                boldTextSerif += String(thisChar)
            } // if-else
        } // for
        return boldTextSerif
    } // boldSerif
    
    private func boldSans(_ stringAsUnicode: [Int]) -> String {
        var boldTextSans = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldTextSans += String(UnicodeScalar(num + 120211) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldTextSans += String(UnicodeScalar(num + 120205) ?? UnicodeScalar(0))
            } else {
                boldTextSans += String(thisChar)
            }
        }
        return boldTextSans
    } // boldSans
    
    private func italicSerif(_ stringAsUnicode: [Int]) -> String {
        var italicTextSerif = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar == "h" {
                italicTextSerif += "ℎ"
            } else if thisChar.isUppercase {
                italicTextSerif += String(UnicodeScalar(num + 119795) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                italicTextSerif += String(UnicodeScalar(num + 119789) ?? UnicodeScalar(0))
            } else {
                italicTextSerif += String(thisChar)
            }
        }
        return italicTextSerif
    } // italicSerif
    
    private func italicSans(_ stringAsUnicode: [Int]) -> String {
        var italicTextSans = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                italicTextSans += String(UnicodeScalar(num + 120263) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                italicTextSans += String(UnicodeScalar(num + 120257) ?? UnicodeScalar(0))
            } else {
                italicTextSans += String(thisChar)
            }
        }
        return italicTextSans
    } // italicSans
    
    private func boldItalicSerif(_ stringAsUnicode: [Int]) -> String {
        var boldItalicSerif = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldItalicSerif += String(UnicodeScalar(num + 119847) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldItalicSerif += String(UnicodeScalar(num + 119841) ?? UnicodeScalar(0))
            } else {
                boldItalicSerif += String(thisChar)
            }
        }
        return boldItalicSerif
    } // boldItalicSerif
    
    private func boldItalicSans(_ stringAsUnicode: [Int]) -> String {
        var boldItalicSans = String()
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldItalicSans += String(UnicodeScalar(num + 120315) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldItalicSans += String(UnicodeScalar(num + 120309) ?? UnicodeScalar(0))
            } else {
                boldItalicSans += String(thisChar)
            }
        }
        return boldItalicSans
    } // boldItalicSans
}

class UserSettings: ObservableObject {
    @Published var savedVersion: String {
        didSet {
            UserDefaults.standard.set(savedVersion, forKey: "savedVersion")
        }
    }
    @Published var notFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(notFirstLaunch, forKey: "notFirstLaunch")
        }
    }
    
    init() {
        self.savedVersion = UserDefaults.standard.string(forKey: "savedVersion") ?? "1.0"
        self.notFirstLaunch = UserDefaults.standard.bool(forKey: "notFirstLaunch")
    }
}
