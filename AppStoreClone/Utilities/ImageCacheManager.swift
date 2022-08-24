//
//  ImageCacheManager.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class ImageCacheManager {
    // MARK: - Properties
    static let shared = NSCache<NSString, UIImage>()
    private let memoryWarningNotification = UIApplication.didReceiveMemoryWarningNotification
    
    // MARK: - Initializers
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeAll),
            name: memoryWarningNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: memoryWarningNotification, object: nil)
    }
    
    // MARK: - Methods
    static func getObject(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        let cachedImage = shared.object(forKey: cacheKey)
        return cachedImage
    }
    
    static func setObject(image: UIImage, forKey key: String) {
        let cacheKey = NSString(string: key)
        shared.setObject(image, forKey: cacheKey)
    }
    
    @objc
    private func removeAll() {
        ImageCacheManager.shared.removeAllObjects()
    }
}
