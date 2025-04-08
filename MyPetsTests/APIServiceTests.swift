//
//  APIServiceTests.swift
//  MyPets
//
//  Created by Sagar Amin on 3/29/25.
//

import XCTest
import Combine
@testable import MyPets

class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        apiService = APIService()
        cancellables = []
    }
    
    override func tearDown() {
        apiService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchDogs() {
        let expectation = XCTestExpectation(description: "Fetch dogs completes")
        
        apiService.fetchDogs()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { pets in
                XCTAssertFalse(pets.isEmpty, "Should receive some dogs")
                XCTAssertEqual(pets.first?.type, .dog, "Pets should be of type dog")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchCats() {
        let expectation = XCTestExpectation(description: "Fetch cats completes")
        
        apiService.fetchCats()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { pets in
                XCTAssertFalse(pets.isEmpty, "Should receive some cats")
                XCTAssertEqual(pets.first?.type, .cat, "Pets should be of type cat")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}
