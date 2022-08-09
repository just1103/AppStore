//
//  ScreenshotViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import Foundation
import Combine

final class ScreenshotViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let rightBarButtonDidTap: AnyPublisher<Void, Never>
//        let cellDidScroll: AnyPublisher<Void, Never>  // TODO: 추가 구현
    }
    
    struct Output {
        let screenshotURLs: AnyPublisher<[String], Never>
    }
    
    // MARK: - Properties
    private weak var coordinator: ScreenshotCoordinator!
    private let screenshotURLs: [String]
    private var currentIndex = 0  // TODO: 활용
    private var cancellableBag = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(coordinator: ScreenshotCoordinator, screenshotURLs: [String], selectedIndex: Int) {
        self.coordinator = coordinator
        self.screenshotURLs = screenshotURLs
        self.currentIndex = selectedIndex
    }
    
    deinit {
        coordinator.finish()
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let screenshotURLs = configureScreenshot()
        configureRightBarButtonDidTapObserver(by: input.rightBarButtonDidTap)
        
        let output = Output(
            screenshotURLs: screenshotURLs
        )
        
        return output
    }
                            
    private func configureScreenshot() -> AnyPublisher<[String], Never> {
        return Just(self.screenshotURLs).eraseToAnyPublisher()
    }
    
    private func configureRightBarButtonDidTapObserver(by inputObservable: AnyPublisher<Void, Never>) {
        inputObservable
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.popCurrentPage()
            })
            .store(in: &cancellableBag)
    }
}
