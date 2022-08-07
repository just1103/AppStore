//
//  NetworkProviderTests.swift
//  IdusIntroductionTests
//
//  Created by Hyoju Son on 2022/08/07.
//

import XCTest
import Combine
@testable import IdusIntroduction

class NetworkProviderTests: XCTestCase {
    var sut: NetworkProvider!
    var cancellableBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkProvider()
        cancellableBag = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        cancellableBag = nil
    }

    func test_IdusAppLookupAPI가_정상작동_하는지() throws {
        let expectation = XCTestExpectation(description: "IdusAppLookupAPI 비동기 테스트")
       
        let publisher = sut.fetchData(
            api: IdusIntroductionURL.IdusAppLookupAPI(),
            decodingType: SearchResultDTO.self
        )
        
        publisher.sink(receiveCompletion: { _ in
        }, receiveValue: { searchResultDTO in
            XCTAssertNotNil(searchResultDTO)
            XCTAssertEqual(searchResultDTO.resultCount, 1)
            
            expectation.fulfill()
        })
        .store(in: &cancellableBag)
        
        wait(for: [expectation], timeout: 10.0)
    }
}
