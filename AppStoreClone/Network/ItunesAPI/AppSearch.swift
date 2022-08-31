//
//  AppSearch.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/31.
//

import Combine
import Foundation

extension ItunesAPI {
    struct AppSearch: Gettable {
        let session: URLSessionProtocol
        var baseURL = ItunesAPI.baseURL
        var headers = ItunesAPI.headers
        var path = "/search"
        private var country = "kr"
        private var limit = "30"
        private let searchQuery: String
        var parameters: [String : String] {
            return [
                "country": country,
                "media": "software",
                "limit": limit,
                "term": searchQuery
            ]
        }

        init(
            searchQuery: String,
            session: URLSessionProtocol = URLSession.shared,
            baseURL: String = ItunesAPI.baseURL
        ) {
            self.searchQuery = searchQuery
            self.session = session
            self.baseURL = baseURL
        }
        
        func fetchData() -> AnyPublisher<SearchResultDTO, NetworkError> {
            guard let urlRequest = self.urlRequest else {
                return Fail(error: NetworkError.invalidURL)
                    .eraseToAnyPublisher()
            }
            
            return session.request(urlRequest: urlRequest)
        }
    }
}
