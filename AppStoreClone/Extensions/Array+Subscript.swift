//
//  Array+Subscript.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
