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

class FancyTextModel: ObservableObject {
    @Published var userInput = String()
    @Published var outputs = [FancyText]()
    @Published var finalOutput = String()
    
    @Published var isFullApp: Bool
    @Published var isExpanded: Bool
    
    var expand: (() -> Void)!
    var dismiss: (() -> Void)!
    var insert: (() -> Void)!
    
    init(_ val: Bool) {
        isFullApp = val
        isExpanded = val
    }
    
    func convertText(_ userInput: String) {
        
        outputs = [FancyText]()
        
        let sanitizedInput = userInput.applyingTransform(.stripDiacritics, reverse: false) ?? ""
        
        var stringAsUnicode = [Int]()
        for char in sanitizedInput.unicodeScalars {
            stringAsUnicode.append(Int(char.value))
        }
        
        // Full-Width Romaji
        var fullWidth = FancyText("Full Width")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            if thisChar == " " {
                fullWidth.value += "　"
            } else if thisChar == "." {
                fullWidth.value += "．"
            } else {
                fullWidth.value += String(UnicodeScalar(num + 65248) ?? UnicodeScalar(0))
            }
        }
        outputs.append(fullWidth)
        
        // Circle Text
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
            }
        }
        outputs.append(circleText)
        
        // Sharp Box Text
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
            }
        }
        outputs.append(sharpBox)
        
        // Round Box Text
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
            }
        }
        outputs.append(roundBoxText)
        
        // Sponge Text
        var spongeText = FancyText("Sarcastic")
        var spongeCounter = 0
        for char in userInput {
            if spongeCounter % 2 == 0 {
                spongeText.value += char.lowercased()
            } else {
                spongeText.value += char.uppercased()
            }
            if char.isLetter {
                spongeCounter += 1
            }
        }
        outputs.append(spongeText)
        
        // Slash Text
        var xText = FancyText("Little X")
        for char in userInput {
            xText.value += String(char)
            xText.value += String(UnicodeScalar(829) ?? UnicodeScalar(0))
        }
        outputs.append(xText)
        
        // Strikethrough Text
        var strikethroughText = FancyText("Strikethrough")
        for char in userInput {
            strikethroughText.value += String(char)
            strikethroughText.value += String(UnicodeScalar(822) ?? UnicodeScalar(0))
        }
        outputs.append(strikethroughText)
        
        // Underline Text
        var underlineText = FancyText("Underline")
        for char in userInput {
            underlineText.value += String(char)
            underlineText.value += String(UnicodeScalar(817) ?? UnicodeScalar(0))
        }
        outputs.append(underlineText)
        
        // Bold Text Serif
        var boldTextSerif = FancyText("Bold Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldTextSerif.value += String(UnicodeScalar(num + 119743) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldTextSerif.value += String(UnicodeScalar(num + 119737) ?? UnicodeScalar(0))
            } else {
                boldTextSerif.value += String(thisChar)
            }
        }
        outputs.append(boldTextSerif)
        
        // Bold Text Sans
        var boldTextSans = FancyText("Bold Sans Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldTextSans.value += String(UnicodeScalar(num + 120211) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldTextSans.value += String(UnicodeScalar(num + 120205) ?? UnicodeScalar(0))
            } else {
                boldTextSans.value += String(thisChar)
            }
        }
        outputs.append(boldTextSans)
        
        // Italic Text Serif
        var italicTextSerif = FancyText("Italic Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar == "h" {
                italicTextSerif.value += "ℎ"
            } else if thisChar.isUppercase {
                italicTextSerif.value += String(UnicodeScalar(num + 119795) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                italicTextSerif.value += String(UnicodeScalar(num + 119789) ?? UnicodeScalar(0))
            } else {
                italicTextSerif.value += String(thisChar)
            }
        }
        outputs.append(italicTextSerif)
        
        // Italic Text Sans
        var italicTextSans = FancyText("Italic Sans Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                italicTextSans.value += String(UnicodeScalar(num + 120263) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                italicTextSans.value += String(UnicodeScalar(num + 120257) ?? UnicodeScalar(0))
            } else {
                italicTextSans.value += String(thisChar)
            }
        }
        outputs.append(italicTextSans)
        
        // Bold Italic Serif
        var boldItalicSerif = FancyText("Bold Italic Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldItalicSerif.value += String(UnicodeScalar(num + 119847) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldItalicSerif.value += String(UnicodeScalar(num + 119841) ?? UnicodeScalar(0))
            } else {
                boldItalicSerif.value += String(thisChar)
            }
        }
        outputs.append(boldItalicSerif)
        
        // Bold Italic Sans
        var boldItalicSans = FancyText("Bold Italic Sans Serif")
        for i in 0..<stringAsUnicode.count {
            let num = stringAsUnicode[i]
            let thisChar = Character(UnicodeScalar(num) ?? UnicodeScalar(0))
            
            if thisChar.isUppercase {
                boldItalicSans.value += String(UnicodeScalar(num + 120315) ?? UnicodeScalar(0))
            } else if thisChar.isLowercase {
                boldItalicSans.value += String(UnicodeScalar(num + 120309) ?? UnicodeScalar(0))
            } else {
                boldItalicSans.value += String(thisChar)
            }
        }
        outputs.append(boldItalicSans)
        
    } // convertText
}
