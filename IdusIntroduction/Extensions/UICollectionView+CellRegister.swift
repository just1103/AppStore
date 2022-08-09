//
//  UICollectionView+Register.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
