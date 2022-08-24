//
//  MainStackView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

protocol AppShareActivityViewPresenterDelegate: AnyObject {
    func shareButtonDidTap()
}

final class MainStackView: UIStackView {
    // MARK: - Properties
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.appIconImageViewCornerRadius
        imageView.layer.borderWidth = Design.appIconImageViewBorderWidth
        imageView.layer.borderColor = Design.appIconImageViewBorderColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.numberOfLines = 0  
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let genreLabel: UILabel = {  
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    private(set) var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Text.shareButtonImageSystemName), for: .normal)
        return button
    }()
    
    weak var delegate: AppShareActivityViewPresenterDelegate?
    
    // MARK: - Initializers
    convenience init() {
        self.init(frame: .zero)
        configureView()
        configureShareButton()
        configureHierarchy()
    }
    
    // MARK: - Methods
    func apply(appIconURL: String, title: String, genre: String) {
        appIconImageView.loadCachedImage(of: appIconURL)
        titleLabel.text = title
        genreLabel.text = genre
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .top
        distribution = .fill
        spacing = 12
    }
    
    private func configureShareButton() {
        shareButton.addTarget(delegate, action: #selector(shareButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func shareButtonDidTap() {
        delegate?.shareButtonDidTap()
    }
    
    private func configureHierarchy() {
        addArrangedSubview(appIconImageView)
        addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(titleLabel)
        titleDescriptionStackView.addArrangedSubview(genreLabel)
        addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor),
            appIconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            shareButton.bottomAnchor.constraint(equalTo: appIconImageView.bottomAnchor),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
        ])
    }
}

// MARK: - Namespace
extension MainStackView {
    private enum Text {
        static let shareButtonImageSystemName = "square.and.arrow.up"
    }

    private enum Design {
        static let appIconImageViewCornerRadius: CGFloat = 12
        static let appIconImageViewBorderWidth: CGFloat = 0.5
        static let appIconImageViewBorderColor: CGColor = UIColor.systemGray.cgColor
    }
}
