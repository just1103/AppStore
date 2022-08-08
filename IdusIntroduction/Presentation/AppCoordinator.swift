//
//  AppCoordinator.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/04.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .app
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        showLookupPage()
    }
    
    private func showLookupPage() {
        guard let navigationController = navigationController else { return }
        let lookupCoordinator = LookupCoordinator(navigationController: navigationController)
        childCoordinators.append(lookupCoordinator)
        lookupCoordinator.start()
    }
}
