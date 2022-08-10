//
//  StarRatingStackView.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/10.
//

import UIKit

class StarRatingStackView: UIStackView {
    // MARK: - Properties
    private let maxStarCount = 5
    
    // MARK: - Initializers
    convenience init() {
        self.init(frame: .zero)
        configureUI()
    }
    
    // MARK: - Methods
    func apply(rating: Double) {
        let starImageViews = configureStarImageView(with: rating)
        configureHierarchy(with: starImageViews)
    }
    
    private func configureUI() {
        configureStackView()
    }
    
    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = -1
    }
    
    private func configureStarImageView(with rating: Double) -> [StarImageView] {
        let filledStarCount = Int(rating)

        let remainder = rating.truncatingRemainder(dividingBy: 1)
        let halfFilledStarCount = remainder >= 0.5 ? 1 : 0
        
        let emptyStarCount = maxStarCount - filledStarCount - halfFilledStarCount
                
        var starImageViews = [StarImageView]()
        starImageViews += (0..<filledStarCount).map { _ in StarImageView(kind: .filled) }
        starImageViews += (0..<halfFilledStarCount).map { _ in StarImageView(kind: .halfFilled) }
        starImageViews += (0..<emptyStarCount).map { _ in StarImageView(kind: .empty) }
        
        return starImageViews
    }
    
    private func configureHierarchy(with starImageViews: [StarImageView]) {
        starImageViews.forEach { addArrangedSubview($0) }
        
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: topAnchor),
//            leadingAnchor.constraint(equalTo: leadingAnchor),
//            trailingAnchor.constraint(equalTo: trailingAnchor),
//            bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
    }
}
