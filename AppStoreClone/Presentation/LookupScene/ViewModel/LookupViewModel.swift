//
//  LookupViewModel.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/08.
//

import Combine
import Foundation

final class LookupViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let searchTextDidReturn: AnyPublisher<String, Never>
    }
    
    struct Output {
        let isAPIResponseValid: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Properties
    private weak var coordinator: LookupCoordinator!
    private let cancellableBag = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(coordinator: LookupCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let isAPIResponseValid = configureSearchTextDidReturnSubscriber(for: input.searchTextDidReturn)
        
        let output = Output(isAPIResponseValid: isAPIResponseValid)
        
        return output
    }
    
    private func configureSearchTextDidReturnSubscriber(
        for inputPublisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<Bool, Never> {
        return inputPublisher
            .filter { $0.isEmpty == false }
            .flatMap { [weak self] searchText -> AnyPublisher<Bool, Never> in
                guard let self = self else { return Just(false).eraseToAnyPublisher() }
                
                return self.fetchData(with: searchText)
                    .map { searchResultDTO -> Bool in
                        guard
                            searchResultDTO.resultCount == 1,
                            let appItemDTO = searchResultDTO.results.first
                        else {
                            return false
                        }
                        
                        let appItem = AppItem.convert(appItemDTO: appItemDTO)
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.coordinator.showDetailPage(with: appItem)
                        }
                        
                        return true
                    }
                    .replaceError(with: false)
                    .eraseToAnyPublisher()

            }
            .eraseToAnyPublisher()
    }
    
    private func fetchData(with searchText: String) -> AnyPublisher<SearchResultDTO, NetworkError> {
        return ItunesAPI.AppLookup(appID: searchText).fetchData()
//        return ItunesAPI.AppSearch(searchQuery: searchText).fetchData()  // AppStore 앱과 동일한 기능
    }
}
