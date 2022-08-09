//
//  CoordinatorProtocol.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import UIKit

enum CoordinatorType {
    case app
    case lookup, detail
    case screenshot
}

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
}
