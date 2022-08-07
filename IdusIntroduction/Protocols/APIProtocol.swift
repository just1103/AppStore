//
//  APIProtocol.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation

protocol APIProtocol {
    var url: URL? { get }
    var method: HttpMethod { get }
}

protocol Gettable: APIProtocol { }

enum HttpMethod {
    case get
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}
