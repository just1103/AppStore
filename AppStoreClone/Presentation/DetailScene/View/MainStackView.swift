//
//  MainStackView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class MainStackView: UIStackView {  // TODO: 공유 버튼 추가 및 Delegate 적용
    // MARK: - Properties
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.thumbnailImageViewCornerRadius
        imageView.layer.borderWidth = Design.thumbnailImageViewBorderWidth
        imageView.layer.borderColor = Design.thumbnailImageViewBorderColor
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .label
        label.numberOfLines = 0  // TODO: 0으로 긴 텍스트에 대응
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let genreLabel: UILabel = {  // TODO: 하단에 공유 버튼 추가하고 정렬 조정
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray3
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializers
    convenience init() {
        self.init(frame: .zero)
        configureStackView()
        configureHierarchy()
    }
    
    // MARK: - Methods
    func apply(thumbnailURL: String, title: String, genre: String) {
        thumbnailImageView.loadCachedImage(of: thumbnailURL)
        titleLabel.text = title
        genreLabel.text = genre
    }
    
    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .fill
        spacing = 12
    }
    
    private func configureHierarchy() {
        addArrangedSubview(thumbnailImageView)
        addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(titleLabel)
        titleDescriptionStackView.addArrangedSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
        ])
    }

}

// MARK: - Namespace
extension MainStackView {
    private enum Design {
        static let thumbnailImageViewCornerRadius: CGFloat = 12
        static let thumbnailImageViewBorderWidth: CGFloat = 1
        static let thumbnailImageViewBorderColor: CGColor = UIColor.systemGray3.cgColor
    }
}
