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
        if isAPIAvailable() {
            showIdusDetailPage()
        } else {
            // TODO: Alert 띄우기 - API의 응답이 invalidate
            // 또는 API 에러화면 띄우기 (refresh 버튼으로 재시도)
        }
    }
    
    private func isAPIAvailable() -> Bool {  // 연산 프로퍼티로 바꿔도 될듯
        // TODO: API 요청, 결과 확인하여 Bool 반환
        return true
    }
        
    
    private func showIdusDetailPage() {
        guard let navigationController = navigationController else { return }
//        let idusDetailCoordinator = IdusDetailCoordinator(navigationController: navigationController)
//        childCoordinators.append(idusDetailCoordinator)
//        idusDetailCoordinator.start()
    }
}
