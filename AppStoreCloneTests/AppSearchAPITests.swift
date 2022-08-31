//
//  AppSearchAPITests.swift
//  AppStoreCloneTests
//
//  Created by Hyoju Son on 2022/09/01.
//

import Combine
import XCTest
@testable import AppStoreClone

class AppSearchAPITests: XCTestCase {
    var sut: ItunesAPI.AppSearch!
    var cancellableBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let idusAppSearchQuery: String = "아이디어스"
        sut = ItunesAPI.AppSearch(searchQuery: idusAppSearchQuery)
        cancellableBag = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellableBag = nil
    }
    
    func test_Idus_AppID로_AppSearchAPI가_정상작동_하는지() {
        // URL : http://itunes.apple.com/search?limit=30&term=%EC%95%84%EC%9D%B4%EB%94%94%EC%96%B4%EC%8A%A4&country=kr&media=software
        let expectation = XCTestExpectation(description: "AppSearchAPI 비동기 테스트")

        let publisher = sut.fetchData()

        publisher.sink(receiveCompletion: { completion in
            if case .failure(_) = completion {
                XCTFail()
            }
        }, receiveValue: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 30)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "아이디어스(idus)")
            XCTAssertEqual(appItem.artistName, "Backpackr Inc.")

            expectation.fulfill()
        })
        .store(in: &cancellableBag)

        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_KakaoTalk_AppID로_AppSearchAPI가_정상작동_하는지() {
        // URL : http://itunes.apple.com/search?country=kr&media=software&limit=30&term=%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1
        let expectation = XCTestExpectation(description: "AppSearchAPI 비동기 테스트")

        let kakaoTalkAppSearchQuery = "카카오톡"
        sut = ItunesAPI.AppSearch(searchQuery: kakaoTalkAppSearchQuery)
        let publisher = sut.fetchData()

        publisher.sink(receiveCompletion: { completion in
            if case .failure(_) = completion {
                XCTFail()
            }
        }, receiveValue: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 30)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "카카오톡 KakaoTalk")
            XCTAssertEqual(appItem.artistName, "Kakao Corp.")

            expectation.fulfill()
        })
        .store(in: &cancellableBag)

        wait(for: [expectation], timeout: 10.0)
    }
}
