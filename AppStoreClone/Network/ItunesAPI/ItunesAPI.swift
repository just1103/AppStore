//
//  ItunesAPI.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation

struct ItunesAPI {
    static let baseURL: String = "http://itunes.apple.com"
    static var headers: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
}
