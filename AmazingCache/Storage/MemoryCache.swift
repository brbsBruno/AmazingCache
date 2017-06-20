//
//  MemoryCache.swift
//  AmazingCache
//
//  Created by Bruno Barbosa on 18/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit

final class MemoryCache {
    
    static let shared = MemoryCache()
    
    // MARK: - Properties
    
    let countLimit: Int = 0
    
    // MARK: Variables
    
    private var storage = [String: Data]()
    private var storageIndex = NSMutableOrderedSet()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(purgeData), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    // Mark: -
    
    func setData(_ data: Data, forKey key: String) {
        if countLimit == 0 || storageIndex.count < countLimit {
            storage[key] = data
            storageIndex.add(key)
            
        } else {
            purgeData()
            setData(data, forKey: key)
        }
    }
    
    func object(forKey key: String) -> Data? {
        if storageIndex.contains(key) {
            if let data = storage[key] {
                self.storageIndex.remove(key)
                self.storageIndex.add(key)
                
                return data
            }
        }
        
        return nil
    }
    
    func removeData(forKey key: String) {
        storage.removeValue(forKey: key)
        storageIndex.remove(key)
    }
    
    @objc func purgeData() {
        if let lastObject = storageIndex.firstObject as? String {
            removeData(forKey: lastObject)
        }
    }
}