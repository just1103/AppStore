//
//  MockURLSession.swift
//  IdusIntroductionTests
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation
import Combine
@testable import IdusIntroduction

//class MockNetworkProvider: URLSessionProtocol {
//    var isRequestSuccess: Bool
//    
//    init(isRequestSuccess: Bool = true) {  
//        self.isRequestSuccess = isRequestSuccess
//    }
//    
//    func fetchData(for request: URLRequest) -> AnyPublisher<PublisherOutput, URLError> {
//        guard
//            let path = Bundle(for: type(of: self)).path(forResource: "MockIdusSearchResult", ofType: "json"),
//            let jsonString = try? String(contentsOfFile: path),
//            let jsonData = jsonString.data(using: .utf8)
//        else {
//            fatalError()
//        }
//        
//        let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2", headerFields: nil)!
//        let serverErrorResponse = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "2", headerFields: nil)!
//        
//        if isRequestSuccess {
//            return Just((data: jsonData, response: successResponse))
//                .setFailureType(to: URLError.self)
//                .eraseToAnyPublisher()
//        } else {
//            return Just((data: Data(), response: serverErrorResponse))  // TODO: 에러반환 개선
//                .setFailureType(to: URLError.self)
//                .eraseToAnyPublisher()
//        }
//    }
//}
