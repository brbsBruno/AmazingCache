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
    
    func testCapacityOverflow() {
        let instance = MemoryCache.shared
        let maxCapacity = 4
        instance.capacity = maxCapacity
        
        for index in 1...5 {
            instance.setData("\(index)".data(using: .utf8)!, forKey: "\(index)")
        }
        
        XCTAssertNil(instance.object(forKey: "\(1)"))
    }
    
    func testCapacityChange() {
        let instance = MemoryCache.shared
        let maxCapacity = 5
        instance.capacity = maxCapacity
        
        for index in 1...5 {
            instance.setData("\(index)".data(using: .utf8)!, forKey: "\(index)")
        }
        
        XCTAssertNotNil(instance.object(forKey: "\(1)"))
        instance.capacity = 4
        
        XCTAssertNil(instance.object(forKey: "\(2)"))
    }
    
    func testCacheOutOfMemory() {
        let instance = MemoryCache.shared
        
        for index in 1...5 {
            instance.setData("\(index)".data(using: .utf8)!, forKey: "\(index)")
        }
        
        NotificationCenter.default.post(name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        
        XCTAssertNil(instance.object(forKey: "\(1)"))
        XCTAssertNotNil(instance.object(forKey: "\(2)"))
    }
}
