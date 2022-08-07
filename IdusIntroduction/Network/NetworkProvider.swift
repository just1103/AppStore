//
//  NetworkProvider.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation
import Combine

struct NetworkProvider {
    // MARK: - Properties
    private let session: URLSession
    
    // MARK: - Initializers
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Methods
    func fetchData<T: Decodable>(
        api: Gettable,
        decodingType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        guard let urlRequest = URLRequest(api: api) else {  // TODO: url로 대체 가능한지 확인 (httpmethod 필요 없는지)
            return Fail(error: NetworkError.urlIsNil).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: urlRequest)
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
            .decode(type: decodingType, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                }
                return .unknownError(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - NetworkError
enum NetworkError: Error, LocalizedError {
    case urlIsNil
    case statusCodeError
    case unknownError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .urlIsNil:
            return "정상적인 URL이 아닙니다."
        case .statusCodeError:
            return "정상적인 StatusCode가 아닙니다."
        case .unknownError:
            return "알수 없는 에러가 발생했습니다."
        }
    }
}
