//
//  ImageCacheManager.swift
//  IdusIntroduction
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
    @objc
    func removeAll() {
        ImageCacheManager.shared.removeAllObjects()
    }
}
