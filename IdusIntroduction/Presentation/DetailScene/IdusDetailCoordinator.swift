//
//  IdusDetailCoordinator.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import UIKit

final class DetailCoordinator: CoordinatorProtocol {
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
        showDetailPage()
    }
    
    private func showDetailPage() {
        guard let navigationController = navigationController else { return }
//        let detailViewModel = DetailViewModel(coordinator: self)
//        let detailViewController = DetailViewController(viewModel: detailViewModel)
//        
//        navigationController.pushViewController(detailViewController, animated: false)
    }
}
