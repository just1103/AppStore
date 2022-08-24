//
//  ShareButtonActivityItemSource.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/17.
//

import Foundation
import LinkPresentation

final class AppShareActivityItemSource: NSObject, UIActivityItemSource {
    // MARK: - Properties
    private let appIconURL: String
    private let trackName: String
    private let genreName: String
    private let trackViewURL: String
    
    // MARK: - Initializers
    init(appIconURL: String, trackName: String, genreName: String, trackViewURL: String) {
        self.appIconURL = appIconURL
        self.trackName = trackName
        self.genreName = genreName
        self.trackViewURL = trackViewURL
    }
    
    // MARK: - Methods
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return trackName
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return trackViewURL
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return trackName
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        if let cachedImage = ImageCacheManager.getObject(forKey: appIconURL) {
            metadata.iconProvider = NSItemProvider(object: cachedImage)  // FIXME: AppIcon 넣으면 모서리 둥글게 안나옴
        }
        metadata.title = trackName
        metadata.originalURL = URL(fileURLWithPath: genreName)

        return metadata
    }
}
