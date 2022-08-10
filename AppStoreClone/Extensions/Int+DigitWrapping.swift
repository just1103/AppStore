//
//  Int+DigitWrapping.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/10.
//

import Foundation

extension Int {
    var byDigitWrapping: String {
        var digitWrappedText = String(self)
        
        switch self {
        case ..<1_000:
            return digitWrappedText
        case 1_000..<10_000:
            let digit = 1_000
            let roundedNumber = String(format: "%.0f", Double(self) / Double(digit))
            digitWrappedText = "\(roundedNumber)천"
            return digitWrappedText  // ex. 6900 -> 7천 
        case 10_000...:
            let digit = 10_000
            let roundedNumber = String(format: "%.0f", Double(self) / Double(digit))
            digitWrappedText = "\(roundedNumber)만"
            return digitWrappedText  // ex. 46000 -> 5만
        default:
            return digitWrappedText
        }
    }
}
