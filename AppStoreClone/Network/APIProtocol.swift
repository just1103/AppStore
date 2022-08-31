//
//  APIProtocol.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/07.
//

import Combine
import Foundation

protocol APIProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var parameters: [String: String] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension APIProtocol {
    var url: URL? {  // direct dispatch
        var urlComponents = URLComponents(string: "\(baseURL)\(path)")
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.description
        headers.forEach {
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }
        urlRequest.httpBody = body

        return urlRequest
    }
}

protocol Gettable: APIProtocol {
    func fetchData() -> AnyPublisher<SearchResultDTO, NetworkError>
}

extension Gettable {
    var method: HttpMethod {
        return .get
    }
    
    var body: Data? {
        nil
    }
}

enum HttpMethod {
    case get
    case post
    case put
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
