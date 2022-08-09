//
//  StarImageView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class StarImageView: UIImageView {
    // MARK: - Initializers
    convenience init() {
        self.init(image: UIImage(systemName: Text.emptyStarImageName))
        configureUI()
    }
    
    // MARK: - Methods
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

// MARK: - NameSpaces
extension StarImageView {
    private enum Text {
        static let emptyStarImageName: String = "star"
    }
}
