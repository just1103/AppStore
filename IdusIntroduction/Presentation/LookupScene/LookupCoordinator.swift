//
//  LookupCoordinator.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation

import UIKit

final class LookupCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .lookup
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        showLookupPage()
    }
    
    private func showLookupPage() {

    }
        
    func showDetailPage(with appItem: AppItem) {
        guard let navigationController = navigationController else { return }
//        let detailCoordinator = DetailCoordinator(navigationController: navigationController)
//        childCoordinators.append(detailCoordinator)
//        detailCoordinator.start()
    }
}
