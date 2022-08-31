//
//  AppLookup.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/10.
//

import Combine
import Foundation

extension ItunesAPI {
    struct AppLookup: Gettable {
        let session: URLSessionProtocol
        var baseURL = ItunesAPI.baseURL
        var headers = ItunesAPI.headers
        var path = "/lookup"
        private var country = "kr"
        private let appID: String
        var parameters: [String : String] {
            return [
                "country": country,
                "media": "software",
                "id": "\(appID)"
            ]
        }
        
        init(
            appID: String,
            session: URLSessionProtocol = URLSession.shared,
            baseURL: String = ItunesAPI.baseURL
        ) {
            self.appID = appID
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
