//
//  NetworkProvider.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation

struct NetworkProvider {
    // MARK: - Properties
    private let session: URLSessionProtocol
    
    // MARK: - Initializers
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}
