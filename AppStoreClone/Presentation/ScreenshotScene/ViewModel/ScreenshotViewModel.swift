//
//  ScreenshotViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/09.
//

import Combine
import Foundation

final class ScreenshotViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let rightBarButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let screenshotURLsAndIndex: AnyPublisher<([String], Int), Never>
    }
    
    // MARK: - Properties
    private weak var coordinator: ScreenshotCoordinator!
    private let screenshotURLs: [String]
    private var currentIndex = 0  
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
        let screenshotURLsAndIndex = configureScreenshotAndIndex()
        configureRightBarButtonDidTapSubscriber(for: input.rightBarButtonDidTap)
        
        let output = Output(
            screenshotURLsAndIndex: screenshotURLsAndIndex
        )
        
        return output
    }
                            
    private func configureScreenshotAndIndex() -> AnyPublisher<([String], Int), Never> {
        return Just((self.screenshotURLs, currentIndex)).eraseToAnyPublisher()
    }
    
    private func configureRightBarButtonDidTapSubscriber(for inputPublisher: AnyPublisher<Void, Never>) {
        inputPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.dismissCurrentPage()
            })
            .store(in: &cancellableBag)
    }
}
