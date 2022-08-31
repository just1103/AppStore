//
//  NetworkError.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/31.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlIsNil
    case invalidURL
    case statusCodeError
    case unknownError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .urlIsNil:
            return "URL이 존재하지 않습니다."
        case .invalidURL:
            return "정상적인 URL이 아닙니다."
        case .statusCodeError:
            return "정상적인 StatusCode가 아닙니다."
        case .unknownError:
            return "알수 없는 에러가 발생했습니다."

        }
    }
}
