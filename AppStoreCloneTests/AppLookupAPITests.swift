//
//  NetworkProviderTests.swift
//  AppStoreCloneTests
//
//  Created by Hyoju Son on 2022/08/07.
//

import Combine
import XCTest
@testable import AppStoreClone

class AppLookupAPITests: XCTestCase {
    var sut: ItunesAPI.AppLookup!
    var cancellableBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let idusAppID: String = "872469884"
        sut = ItunesAPI.AppLookup(appID: idusAppID)
        cancellableBag = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellableBag = nil
    }
    
    func test_Idus_AppID로_AppLookupAPI가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "AppLookupAPI 비동기 테스트")

        let publisher = sut.fetchData()

        publisher.sink(receiveCompletion: { completion in
            if case .failure(_) = completion {
                XCTFail()
            }
        }, receiveValue: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 1)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "아이디어스(idus)")
            XCTAssertEqual(appItem.artistName, "Backpackr Inc.")

            expectation.fulfill()
        })
        .store(in: &cancellableBag)

        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_KakaoTalk_AppID로_AppLookupAPI가_정상작동_하는지() {
        let expectation = XCTestExpectation(description: "AppLookupAPI 비동기 테스트")

        let kakaoTalkAppID = "362057947"
        sut = ItunesAPI.AppLookup(appID: kakaoTalkAppID)
        let publisher = sut.fetchData()

        publisher.sink(receiveCompletion: { completion in
            if case .failure(_) = completion {
                XCTFail()
            }
        }, receiveValue: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 1)

            let appItemDTO = searchResultDTO.results.first!
            let appItem = AppItem.convert(appItemDTO: appItemDTO)
            XCTAssertEqual(appItem.trackName, "KakaoTalk")
            XCTAssertEqual(appItem.artistName, "Kakao Corp.")

            expectation.fulfill()
        })
        .store(in: &cancellableBag)

        wait(for: [expectation], timeout: 10.0)
    }
}
