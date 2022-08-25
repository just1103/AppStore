//
//  DetailCoordinator.swift
//  AppStoreClone
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
    
    func finish() {
        delegate.removeFromChildCoordinators(coordinator: self)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
    
    func showScreenshotPage(with screenshotURLs: [String], selectedIndex: Int) {
        guard let navigationController = navigationController else { return }
        let screenshotCoordinator = ScreenshotCoordinator(navigationController: navigationController)
        childCoordinators.append(screenshotCoordinator)
        screenshotCoordinator.delegate = self
        screenshotCoordinator.start(with: screenshotURLs, selectedIndex: selectedIndex)
    }
    
    private func showDetailPage(with appItem: AppItem) {
        guard let navigationController = navigationController else { return }
        let detailViewModel = DetailViewModel(coordinator: self, appItem: appItem)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - ScreenshotCoordinator Delegete
extension DetailCoordinator: ScreenshotCoordinatorDelegete {
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
}
