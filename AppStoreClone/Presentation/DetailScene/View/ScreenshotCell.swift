//
//  ScreenshotCell.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class ScreenshotCell: UICollectionViewCell {
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Design.imageViewCornerRadius
        imageView.layer.borderColor = Design.imageViewBorderColor
        imageView.layer.borderWidth = Design.imageViewBorderWidth
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Methods
    func apply(screenshotURL: String) {
        imageView.loadCachedImage(of: screenshotURL)
    }
    
    private func configureUI() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Namespaces
extension ScreenshotCell {
    private enum Design {
        static let imageViewCornerRadius: CGFloat = 15
        static let imageViewBorderWidth: CGFloat = 1
        static let imageViewBorderColor = UIColor.systemGray3.cgColor
    }
}
