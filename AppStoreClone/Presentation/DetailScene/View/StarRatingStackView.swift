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
        configureStackView()
    }
    
    // MARK: - Methods
    func apply(rating: Double) {
        let starImageViews = configureStarImageView(with: rating)
        configureHierarchy(with: starImageViews)
    }
    
    private func configureStarImageView(with rating: Double) -> [StarImageView] {
        let starCountByKind = calculateStarCountByKind(with: rating)
        
        var starImageViews = [StarImageView]()
        starImageViews += (0..<starCountByKind.filled).map { _ in StarImageView(kind: .filled) }
        starImageViews += (0..<starCountByKind.halfFilled).map { _ in StarImageView(kind: .halfFilled) }
        starImageViews += (0..<starCountByKind.empty).map { _ in StarImageView(kind: .empty) }
        
        return starImageViews
    }
    
    private func calculateStarCountByKind(with rating: Double) -> (filled: Int, halfFilled: Int, empty: Int) {
        let filledStarCount = Int(rating)

        let remainder = rating.truncatingRemainder(dividingBy: 1)
        let halfFilledStarCount = remainder >= 0.5 ? 1 : 0
        
        let emptyStarCount = maxStarCount - filledStarCount - halfFilledStarCount
        
        return (filledStarCount, halfFilledStarCount, emptyStarCount)
    }
    
    private func configureHierarchy(with starImageViews: [StarImageView]) {
        starImageViews.forEach { addArrangedSubview($0) }
    }

    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = -1
    }
}
