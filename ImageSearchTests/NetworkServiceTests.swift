//
//  NetworkServiceTests.swift
//  ImageSearchTests
//
//  Created by Roman Arriaga on 9/10/21.
//

import XCTest
@testable import ImageSearch

class NetworkServiceTests: XCTestCase {

    var networkCaller: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.networkCaller = NetworkService(session: MockSession())
    }

    override func tearDownWithError() throws {
        self.networkCaller = nil
        try super.tearDownWithError()
    }

    func testFetchModelDataSuccess() {
        let expectation = XCTestExpectation(description: "Successfully fetched model data")
        var feed: Feed?
        
        self.networkCaller.requestModel(url: NetworkRequests.feed("Dolphin").url) { (result: Result<Feed, Error>) in
            switch result {
            case .success(let model):
                feed = model
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(feed?.title, "Recent Uploads tagged dolphin and whale")
        XCTAssertEqual(feed?.items.count, 20)
        XCTAssertEqual(feed?.items.first?.title, "Risso's dolphin - Dauphin de Risso (Grampus griseus)")
        
    }
    
    func testFetchRawDataSuccess() {
        let expectation = XCTestExpectation(description: "Successfully Fetched Image data")
        var imageData: Data = Data()
        
        self.networkCaller.requestRawData(url: NetworkRequests.image("Sample.jpeg").url) { result in
            switch result {
            case .success(let data):
                imageData = data
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3)
        
        // Closest to compare is checking for same Sizes as images are not equatable
        XCTAssertEqual(UIImage(data: imageData)?.size, UIImage(named: "Sample")?.size)
    }
    
    func testFetchDataGeneralFail() {
        let expectation = XCTestExpectation(description: "General Error check")
        var error: Error?
        
        self.networkCaller.requestRawData(url: NetworkRequests.image("fail").url) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                error = err
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(error as? NetworkError, NetworkError.badData)
    }

}
