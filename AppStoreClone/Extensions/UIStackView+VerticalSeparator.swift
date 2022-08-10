//
//  UIStackView+VerticalSeparator.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/10.
//

import UIKit

extension UIStackView {
    func addVerticalSeparators(color: UIColor = .systemGray3, heightRatio: CGFloat = 0.5, spacing: CGFloat = 0) {
        let separatorCount = arrangedSubviews.count - 1
        
        (0..<separatorCount).forEach { index in
            guard let subview = subviews[safe: index] else { return }
            
            let separatorView = createVerticalSeparatorView(color: color)
            addSubview(separatorView)
            
            NSLayoutConstraint.activate([
                separatorView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightRatio),
                separatorView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: spacing),
                separatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    private func createVerticalSeparatorView(color: UIColor) -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.backgroundColor = color
        return separator
    }
}
