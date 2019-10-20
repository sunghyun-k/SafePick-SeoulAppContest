//
//  String+KoreanSplit.swift
//  SafePick
//
//  Created by 김성현 on 04/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation

let krFirsts: [String] = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]

let krMiddles: [String] = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]

let krLasts: [String] = ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]


extension Character {
    var krSplited: String {
        
        // 공백은 붙입니다.
        if self == " " { return "" }
        
        let value = unicodeScalars.first!.value
        
        // 한글인지 확인합니다.
        guard (0xAC00...0xD7AF).contains(value) else {
            return String(self)
        }
        
        // 자음만 있는지 확인합니다. (ㄱ...ㅎ)
        if (0x3131...0x314E).contains(value) {
            return String(self)
        }
        
        // 모음만 있는지 확인합니다. (ㅏ...ㅣ)
        if (0x314F...0x3163).contains(value) {
            return String(self)
        }
        
        let characterIndex = Int(value) - 0xAC00
        
        let firstIndex = characterIndex / (28 * 21)
        let middleIndex = characterIndex / 28 % 21
        let lastIndex = characterIndex % 28
        
        let first = krFirsts[firstIndex]
        let middle = krMiddles[middleIndex]
        let last = krLasts[lastIndex]
        
        return first + middle + last
    }
}

extension String {
    var krSplited: String {
        return map { $0.krSplited }.joined()
    }
}
