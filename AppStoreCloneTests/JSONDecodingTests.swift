//
//  AppStoreCloneTests.swift
//  AppStoreClone
//
//  Created by Hyoju Son on 2022/08/04.
//

import XCTest
@testable import AppStoreClone

class JSONDecodingTests: XCTestCase {
    func test_SearchResultDTO타입_decode했을때_Parsing되는지_테스트() {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "MockIdusLookupResult", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path)
        else {
            XCTFail()
            return
        }
        
        guard
            let data = jsonString.data(using: .utf8),
            let result = try? JSONDecoder().decode(SearchResultDTO.self, from: data)
        else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(result.resultCount, 1)
    }
    
    func test_AppItemDTO타입_decode했을때_Parsing되는지_테스트() {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "MockIdusAppItem", ofType: "json"),
            let jsonString = try? String(contentsOfFile: path)
        else {
            XCTFail()
            return
        }
        
        guard
            let data = jsonString.data(using: .utf8),
            let result = try? JSONDecoder().decode(AppItemDTO.self, from: data)
        else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(result.artworkURL100, "https://is4-ssl.mzstatic.com/image/thumb/Purple112/v4/85/99/75/859975c5-eea9-6fea-033c-d42f7cfa31f6/AppIcon-1x_U007emarketing-0-6-0-sRGB-85-220.png/100x100bb.jpg")
        XCTAssertEqual(result.primaryGenreName, "Shopping")
        XCTAssertEqual(result.averageUserRating, 4.756300000000001)
        XCTAssertEqual(result.userRatingCount, 238)
        XCTAssertEqual(result.fileSizeBytes, "124699648")
    }
}
