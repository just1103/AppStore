//
//  SearchResultDTO.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import Foundation

struct SearchResultDTO: Decodable {
    let resultCount: Int
    let results: [AppItemDTO]
}
