//
//  IdusDetailCoordinator.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import UIKit

protocol DetailCoordinatorDelegete: AnyObject {
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class DetailCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    weak var delegate: DetailCoordinatorDelegete!
    var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .detail
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start(with appItem: AppItem) {
        showDetailPage(with: appItem)
    }
    
    private func showDetailPage(with appItem: AppItem) {
        guard let navigationController = navigationController else { return }
        let detailViewModel = DetailViewModel(coordinator: self, appItem: appItem)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        
        navigationController.pushViewController(detailViewController, animated: false)
    }
    
    func finish() {
        delegate.removeFromChildCoordinators(coordinator: self)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}
