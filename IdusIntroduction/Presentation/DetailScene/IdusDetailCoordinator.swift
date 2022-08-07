//
//  IdusDetailCoordinator.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import UIKit

final class IdusDetailCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .detail
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        showIdusDetailPage()
    }
    
    private func showIdusDetailPage() {
        guard let navigationController = navigationController else { return }
//        let idusDetailViewModel = IdusDetailViewModel(coordinator: self)
//        let idusDetailViewController = IdusDetailViewController(viewModel: searchListViewModel)
//        
//        navigationController.pushViewController(idusDetailViewController, animated: false)
    }
}
