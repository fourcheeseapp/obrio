//
//  BitcoinRateServiceImplTests.swift
//  TransactionsTestTaskTests
//
//  Created by Viktor Golovach on 21.02.2025.
//

import XCTest
import Combine
@testable import TransactionsTestTask

class BitcoinRateServiceImplTests: XCTestCase {
    
    private var sut: BitcoinRateServiceImpl!
    private var sut_coreData = ServicesAssembler.coreDataService()
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        sut = BitcoinRateServiceImpl(fetchInterval: 3)
    }
    
    func test_startMonitoringPrice_success() {
        // arrange
        var capturedRate: Double?
        var capturedError: Error?
        let expectation = self.expectation(description: "Rate is captured")
        
        // act
        sut.startMonitoringPrice()
        sut.ratePublisher
            .sink { result in
                switch result {
                case .success(let rate):
                    capturedRate = rate
                    expectation.fulfill()
                case .failure(let error):
                    capturedError = error
                    XCTFail("Expected success, but got failure: \(error)")
                }
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
        
        // assert
        XCTAssertNotNil(capturedRate, "Expected a captured rate, but it was nil")
        XCTAssertNil(capturedError)
    }
    
    func test_topMonitoringPrice_CancelsAllCancellables() {
        // arrange
        let expectation = XCTestExpectation(description: "Monitor price and then stop")
        
        // act
        sut.startMonitoringPrice()
        sut.ratePublisher
            .sink { _ in }
            .store(in: &cancellables)
        
        sut.stopMonitoringPrice()
        
        // assert
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.cancellables.isEmpty, "Cancellables should be empty after stopMonitoringPrice is called.")
            expectation.fulfill()
        }
        expectation.fulfill()
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_DynamicUpdateInterval() {
        // arrange
        let expectation = self.expectation(description: "Rate is fetched multiple times")
        var fetchCount = 0
        
        sut.ratePublisher
            .sink { result in
                if case .success = result {
                    fetchCount += 1
                    if fetchCount == 2 {
                        expectation.fulfill()
                    }
                }
            }
            .store(in: &cancellables)
        
        // act
        sut.startMonitoringPrice()
        
        // assert
        waitForExpectations(timeout: 4.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
}
