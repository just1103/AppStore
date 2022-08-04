//
//  SearchResultDTO.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/04.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [AppItem]
}
