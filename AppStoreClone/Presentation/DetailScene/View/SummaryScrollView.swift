//
//  SummaryScrollView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

final class SummaryScrollView: UIScrollView {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let ratingTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        return label
    }()
    private let ratingContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let starRatingStackView: UIStackView = {  // TODO: Custom 타입으로 추가
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    private let advisoryRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let advisoryRatingTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        label.text = "연령"
        return label
    }()
    private let advisoryRatingContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let advisoryRatingSuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        label.text = "세"
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing  // TODO: 가운데 요소의 크기가 크도록 재조정
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        label.text = "카테고리"
        return label
    }()
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray3
        return imageView
    }()
    private let categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    
    private let developerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let developerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        label.text = "개발자"
        return label
    }()
    private let developerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.square"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray3
        return imageView
    }()
    private let developerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    
    private let languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Design.containerStackViewVerticalInset,
            leading: Design.containerStackViewHorizontalInset,
            bottom: Design.containerStackViewVerticalInset,
            trailing: Design.containerStackViewHorizontalInset
        )
        stackView.spacing = Design.contentStackViewSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let languageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelColor
        label.text = "언어"
        return label
    }()
    private let languageSymbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    private let languageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.contentLabelFont
        label.textColor = Design.contentLabelColor
        return label
    }()
    
    // MARK: - Initializers
    convenience init() {
        self.init(frame: .zero)
        configureUI()
        configureHierarchy()
    }
    
    // MARK: - Methods
    func apply(_ appItem: AppItem) {
        let languages = appItem.languageCodesISO2A
        guard let mainLanguage = appItem.languageCodesISO2A[safe: 0] else { return }
        ratingTitleLabel.text = "\(appItem.userRatingCount)개의 평가"
//        ratingTitleLabel.text = "\(appItem.userRatingCount.byDigitWrapping)개의 평가" // TODO: 단위별로 끊어 읽기
        ratingContentLabel.text = String(format: "%.1f", appItem.userRatingCount)
//        starRatingStackView // 점수 전달하여 처리
        
        advisoryRatingContentLabel.text = "\(appItem.contentAdvisoryRating)"
        
        categoryImageView.image = UIImage(systemName: "cart")  // TODO: 종류에 따라 처리
        categoryDescriptionLabel.text = appItem.primaryGenreName  // TODO: Localization 적용
        
        developerNameLabel.text = appItem.artistName
        
        languageSymbolLabel.text = "\(mainLanguage)"
        if languages.count == 1 {
            languageDescriptionLabel.text = "\(mainLanguage)"  // TODO: Localization 적용
        } else {
            languageDescriptionLabel.text = "+ \(languages.count - 1)개 언어"
        }
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    private func configureHierarchy() {
        addSubview(containerStackView)  // TODO: Separator 추가
        containerStackView.addArrangedSubview(ratingStackView)
        containerStackView.addArrangedSubview(advisoryRatingStackView)
        containerStackView.addArrangedSubview(categoryStackView)
        containerStackView.addArrangedSubview(developerStackView)
        containerStackView.addArrangedSubview(languageStackView)
        
        ratingStackView.addArrangedSubview(ratingTitleLabel)
        ratingStackView.addArrangedSubview(ratingContentLabel)
        ratingStackView.addArrangedSubview(starRatingStackView)
        
        advisoryRatingStackView.addArrangedSubview(advisoryRatingTitleLabel)
        advisoryRatingStackView.addArrangedSubview(advisoryRatingContentLabel)
        advisoryRatingStackView.addArrangedSubview(advisoryRatingSuffixLabel)
        
        categoryStackView.addArrangedSubview(categoryTitleLabel)
        categoryStackView.addArrangedSubview(categoryImageView)
        categoryStackView.addArrangedSubview(categoryDescriptionLabel)
        
        developerStackView.addArrangedSubview(developerTitleLabel)
        developerStackView.addArrangedSubview(developerImageView)
        developerStackView.addArrangedSubview(developerNameLabel)
        
        languageStackView.addArrangedSubview(languageTitleLabel)
        languageStackView.addArrangedSubview(languageSymbolLabel)
        languageStackView.addArrangedSubview(languageDescriptionLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - NameSpace
extension SummaryScrollView {
    private enum Design {
        static let containerStackViewVerticalInset: CGFloat = 10
        static let containerStackViewHorizontalInset: CGFloat = 10
        static let contentStackViewSpacing: CGFloat = 5
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
        static let contentLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
        static let titleLabelColor: UIColor = .systemGray
        static let contentLabelColor: UIColor = .systemGray
    }
}
