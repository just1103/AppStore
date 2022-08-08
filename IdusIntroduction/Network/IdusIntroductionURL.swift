//
//  IdusIntroductionURL.swift
//  IdusIntroduction
//
//  Created by Hyoju Son on 2022/08/07.
//

import Foundation

struct IdusIntroductionURL {
    static let baseURL: String = "http://itunes.apple.com/"
    
    struct IdusAppLookupAPI: Gettable {
        let url: URL?
        let method: HttpMethod = .get
        var headers: [String : String] = [:]
        var body: Data? = nil
        let appID: String = "872469884"  
        
        init(baseURL: String = baseURL) {
            var urlComponents = URLComponents(string: "\(baseURL)lookup?")
            let appIDQuery = URLQueryItem(name: "id", value: "\(self.appID)")
            urlComponents?.queryItems?.append(appIDQuery)
            
            self.url = urlComponents?.url
        }
    }
    
    struct AppLookupAPI: Gettable {
        let url: URL?
        let method: HttpMethod = .get
        var headers: [String : String] = [:]
        var body: Data? = nil

        init(appID: String, baseURL: String = baseURL) {
            var urlComponents = URLComponents(string: "\(baseURL)lookup?")
            let appIDQuery = URLQueryItem(name: "id", value: "\(appID)")
            urlComponents?.queryItems?.append(appIDQuery)

            self.url = urlComponents?.url
        }
    }
}
