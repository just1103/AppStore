//
//  DetailViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation
import Combine

final class DetailViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let leftBarButtonDidTap: AnyPublisher<Void, Never>
//        let screenshotCellDidTap: AnyPublisher<IndexPath, Never>
        let unfoldButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let appItem: AnyPublisher<AppItem, Never>
        let isDescriptionLabelUnfolded: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    private weak var coordinator: DetailCoordinator!
    private let appItem: AppItem!
    private var isCurrentDescriptionLabelUnfolded = false
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
        let isDescriptionLabelUnfolded = configureUnfoldButtonDidTapObserver(by: input.unfoldButtonDidTap)
        
        let output = Output(
            appItem: appItem,
            isDescriptionLabelUnfolded: isDescriptionLabelUnfolded
        )
        
        return output
    }
                            
    private func configureBookItem() -> AnyPublisher<AppItem, Never> {
        return Just(self.appItem).eraseToAnyPublisher()
    }
    
    private func configureLeftBarButtonDidTapObserver(by inputObservable: AnyPublisher<Void, Never>) {
        inputObservable
            .sink(receiveValue: { [weak self] _ in
                self?.coordinator.popCurrentPage()
            })
            .store(in: &cancellableBag)
    }
    
    private func configureUnfoldButtonDidTapObserver(by inputObservable: AnyPublisher<Void, Never>) -> AnyPublisher<Bool, Never> {
        inputObservable
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                self.isCurrentDescriptionLabelUnfolded.toggle()
                return self.isCurrentDescriptionLabelUnfolded
            }
            .eraseToAnyPublisher()
    }
}
