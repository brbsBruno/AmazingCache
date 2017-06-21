//
//  AmazingCacheTests.swift
//  AmazingCacheTests
//
//  Created by Bruno Barbosa on 17/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import XCTest
@testable import AmazingCache

class AmazingCacheTests: XCTestCase {
    
    var amazingCache: AmazingCache!
    
    override func setUp() {
        super.setUp()
        amazingCache =  AmazingCache()
    }
    
    override func tearDown() {
        amazingCache = nil
        super.tearDown()
    }
    
    func testLoadDataWithAmazingCacheSucceed() {
        let cacheSuccess = expectation(description: "Cache loaded object")
        
        let urlString = "http://i.imgur.com/pcENhyi.jpg"
        let testingDataURL = URL(string: urlString)!
        
        amazingCache.loadData(url: testingDataURL) { (result) in
            switch result {
            case .success( _):
                cacheSuccess.fulfill()
            case .failure( _):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoadDataWithAmazingCacheFail() {
        let cacheFail = expectation(description: "Cache failed to loaded object")
        
        let urlString = "fail"
        let testingDataURL = URL(string: urlString)!
        
        amazingCache.loadData(url: testingDataURL) { (result) in
            switch result {
            case .success( _):
                XCTFail()
            case .failure( _):
                cacheFail.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoadSameDataMultipleTimes() {
        let cacheSameData = expectation(description: "Request same data multiple times")
        
        let urlString = "http://i.imgur.com/pcENhyi.jpg"
        let testingDataURL = URL(string: urlString)!
        
        var myData = [Data]()
        
        for index in 1...10 {
            amazingCache.loadData(url: testingDataURL) { (result) in
                switch result {
                case .success(let data):
                    myData.append(data)
                case .failure( _):
                    break
                }
                
                if index == 10 {
                    cacheSameData.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssert(myData.count == 10)
        }
    }
}
