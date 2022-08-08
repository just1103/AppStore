//
//  MockNetworkProviderTests.swift
//  IdusIntroductionTests
//
//  Created by Hyoju Son on 2022/08/08.
//

import XCTest
import Combine
@testable import IdusIntroduction

class MockURLSessionTests: XCTestCase {
    var sut: URLSessionProtocol!
    var cancellableBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockURLSession(isRequestSuccess: true)
        cancellableBag = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellableBag = nil
    }

    func test_request성공시_fetchData가_정상작동_하는지() {
        let idusAppID: String = "872469884"
        let publisher = ItunesAPI.AppLookup(appID: idusAppID, session: sut).fetchData()
        
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
        })
        .store(in: &cancellableBag)
    }
    
    func test_request실패시_fetchData가_정상작동_하는지() {
        sut = MockURLSession(isRequestSuccess: false)
        let idusAppID: String = "872469884"
        let publisher = ItunesAPI.AppLookup(appID: idusAppID, session: sut).fetchData()
        
        publisher.sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTAssertEqual(error.errorDescription, NetworkError.statusCodeError.errorDescription)
            } else {
                XCTFail()
            }
        }, receiveValue: { _ in
            XCTFail()
        })
        .store(in: &cancellableBag)
    }
}
