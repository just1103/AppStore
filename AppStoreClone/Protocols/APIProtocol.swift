//
//  APIProtocol.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/07.
//

import Combine
import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol {
    func fetchData() -> AnyPublisher<SearchResultDTO, NetworkError>
}

enum HttpMethod {
    case get
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
