//
//  DetailViewModel.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation
import Combine

final class DetailViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let leftBarButtonDidTap: PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let appItem: Just<AppItem?>
    }
    
    // MARK: - Properties
    private weak var coordinator: DetailCoordinator!
    private let appItem: AppItem!
    private var cancellableBag = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(coordinator: DetailCoordinator, appItem: AppItem) {
        self.coordinator = coordinator
        self.appItem = appItem
    }
    
    deinit {
        coordinator.finish()
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let appItem = configureBookItem()
        configureLeftBarButtonDidTapObserver(by: input.leftBarButtonDidTap)
        
        let output = Output(appItem: appItem)
        
        return output
    }
                            
    private func configureBookItem() -> Just<AppItem?> {
        return Just(self.appItem)
    }
    
    private func configureLeftBarButtonDidTapObserver(by inputObservable: PassthroughSubject<Void, Never>) {
        inputObservable
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.popCurrentPage()
            })
            .store(in: &cancellableBag)
    }
}
