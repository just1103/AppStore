//
//  ScreenshotCoordinator.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import UIKit

protocol ScreenshotCoordinatorDelegete: AnyObject {
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class ScreenshotCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    weak var delegate: ScreenshotCoordinatorDelegete!
    var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .screenshot
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start(with screenshotURLs: [String], selectedIndex: Int) {
        showScreenshotPage(with: screenshotURLs, selectedIndex: selectedIndex)
    }
    
    func finish() {
        delegate.removeFromChildCoordinators(coordinator: self)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showScreenshotPage(with screenshotURLs: [String], selectedIndex: Int) {
        guard let navigationController = navigationController else { return }
        let screenshotViewModel = ScreenshotViewModel(
            coordinator: self,
            screenshotURLs: screenshotURLs,
            selectedIndex: selectedIndex
        )
        let screenshotViewController = ScreenshotViewController(viewModel: screenshotViewModel)

        navigationController.pushViewController(screenshotViewController, animated: false)
    }
}
