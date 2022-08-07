//
//  CoordinatorProtocol.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/04.
//

import UIKit

enum CoordinatorType {
    case app
    case detail   
}

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [CoordinatorProtocol] { get set }
    var type: CoordinatorType { get }
}
