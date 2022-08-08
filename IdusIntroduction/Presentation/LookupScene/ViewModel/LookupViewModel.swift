//
//  LookupViewModel.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/08.
//

import Foundation
import Combine

final class LookupViewModel: ViewModelProtocol {
    // MARK: - Nested Types
    struct Input {
        let searchTextDidReturn: PassthroughSubject<String, Never> // TODO: AnyPublisher로 변경
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
        let isAPIResponseValid = configureSearchTextDidReturnObserver(by: input.searchTextDidReturn)
        
        let output = Output(isAPIResponseValid: isAPIResponseValid)
        
        return output
    }
    
    private func configureSearchTextDidReturnObserver(
        by searchText: PassthroughSubject<String, Never>
    ) -> AnyPublisher<Bool, Never> {
        return searchText
            .removeDuplicates()
            .map { [weak self] searchText -> Bool in
                guard let self = self else { return false }
                
                // FIXME: 반환타입 꼬이는 문제
                return self.fetchData(with: searchText)
                    .map { searchResultDTO -> AnyPublisher<Bool, Never> in
                        guard
                            searchResultDTO.resultCount == 1,
                            let appItemDTO = searchResultDTO.results.first
                        else {
                            return false
                        }
                        
                        let appItem = AppItem.convert(appItemDTO: appItemDTO)
                        self.coordinator.showDetailPage(with: appItem)
                        return true
                    }
                
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchData(with searchText: String) -> AnyPublisher<SearchResultDTO, NetworkError> {
        return ItunesAPI.AppLookup(appID: searchText).fetchData()
    }
}
