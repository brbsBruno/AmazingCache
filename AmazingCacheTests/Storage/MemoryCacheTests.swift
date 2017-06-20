//
//  MemoryCacheTests.swift
//  AmazingCacheTests
//
//  Created by Bruno Barbosa on 19/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import XCTest
@testable import AmazingCache

class MemoryCacheTests: XCTestCase {
    
    func testSharedInstance() {
        let instance = MemoryCache.shared
        XCTAssertNotNil(instance, "")
    }
    
    func testSharedSingleInstance() {
        let firstInstance = MemoryCache.shared
        let secondInstance = MemoryCache.shared
        XCTAssertTrue(firstInstance === secondInstance)
    }
    
    func testSharedInDifferentThreads() {
        var firstInstance : MemoryCache!
        var secondInstance : MemoryCache!
        
        let firstExpectation = expectation(description: "First Expectation")
        DispatchQueue(label: "first_thread").async {
            firstInstance = MemoryCache.shared
            firstExpectation.fulfill()
        }
        
        let secondExpectation = expectation(description: "Second Expectation")
        DispatchQueue(label: "first_thread").async {
            secondInstance = MemoryCache.shared
            secondExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertTrue(firstInstance === secondInstance)
        }
    }
}
