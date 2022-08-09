//
//  ResultDTO.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import Foundation

struct AppItemDTO: Decodable {
    let artworkURL100: String
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Double
    let userRatingCount: Int  // TODO: 52313값 확인
    let screenshotURLs: [String]
    let version: String
    let currentVersionReleaseDate: String
    let releaseNotes: String
    let appDescription: String
    let artistName: String
    let fileSizeBytes: String
    let languageCodesISO2A: [String]
    let contentAdvisoryRating: String
    let formattedPrice: String
    
    enum CodingKeys: String, CodingKey {
        case artworkURL100 = "artworkUrl100"
        case trackName, primaryGenreName, averageUserRating, userRatingCount
        case screenshotURLs = "screenshotUrls"
        case version, currentVersionReleaseDate, releaseNotes
        case appDescription = "description"
        case artistName, fileSizeBytes, languageCodesISO2A, contentAdvisoryRating, formattedPrice
    }
}
