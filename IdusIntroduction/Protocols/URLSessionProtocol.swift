//
//  URLSessionProtocol.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation
import Combine

protocol URLSessionProtocol {
    func request<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, NetworkError>
}

extension URLSession: URLSessionProtocol {
    func request<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, NetworkError> {
        return dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> Data in
                let successStatusCode = 200..<300
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    successStatusCode.contains(httpResponse.statusCode)
                else {
                    throw NetworkError.statusCodeError
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                }
                return .unknownError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
