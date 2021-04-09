//
//  ClassifiedServiceTest.swift
//  ClassifiedTests
//
//  Created by Amir on 09/04/2021.
//

import Foundation
import XCTest
import NetworkModule
@testable import Classified

final class ClassifiedServiceTest: XCTestCase {
    var service: ClassifiedServiceType!
    
    override func setUp() {
        let network = MockClassifiedAPI()
        service = ClassifiedService(network: network)
    }
    
    func testFetchClassifiedAds() {
        let ext = expectation(description: "fetch classified ads")
        service.fetchClassifiedAds { result in
            switch result {
            case .success(let ad):
                XCTAssertEqual(ad.results.count, 3)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            ext.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

final class MockClassifiedAPI: ClassifiedAPI {
    func requestClassifiedAds(completion: @escaping (Result<ClassifiedList, RequestError>) -> Void) {
        completion(.success(ClassifiedList(results: [
            Classified.fake(created_at: "2019-02-24 04:04:17.566515", price: "AED 5", name: "Notebook"),
            Classified.fake(created_at: "2019-02-23 07:56:26.686128", price: "AED 500", name: "Glasses"),
            Classified.fake(created_at: "2019-02-27 11:21:59.983164", price: "AED 50", name: "monitor")
        ])))
    }
}
