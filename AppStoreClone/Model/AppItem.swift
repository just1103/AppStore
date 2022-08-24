//
//  AppItem.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import Foundation

struct AppItem {
    let artworkURL100: String
    let trackName: String
    let primaryGenreName: String
    let trackViewURL: String
    let averageUserRating: Double
    let userRatingCount: Int
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
    
    static func convert(appItemDTO: AppItemDTO) -> AppItem {
        return AppItem(
            artworkURL100: appItemDTO.artworkURL100,
            trackName: appItemDTO.trackName,
            primaryGenreName: appItemDTO.primaryGenreName,
            trackViewURL: appItemDTO.trackViewURL,
            averageUserRating: appItemDTO.averageUserRating,
            userRatingCount: appItemDTO.userRatingCount,
            screenshotURLs: appItemDTO.screenshotURLs,
            version: appItemDTO.version,
            currentVersionReleaseDate: appItemDTO.currentVersionReleaseDate,
            releaseNotes: appItemDTO.releaseNotes,
            appDescription: appItemDTO.appDescription,
            artistName: appItemDTO.artistName,
            fileSizeBytes: appItemDTO.fileSizeBytes,
            languageCodesISO2A: appItemDTO.languageCodesISO2A,
            contentAdvisoryRating: appItemDTO.contentAdvisoryRating,
            formattedPrice: appItemDTO.formattedPrice
        )
    }
}
