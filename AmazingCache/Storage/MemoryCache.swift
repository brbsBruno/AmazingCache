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
    
    var capacity: Int = 0 {
        didSet {
            if capacity != 0 {
                while storageIndex.count > capacity {
                    purgeLeastRecentlyUsed()
                }
            }
        }
    }
    
    // MARK: Variables
    
    private var storage = [String: Data]()
    private var storageIndex = NSMutableOrderedSet()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(purgeLeastRecentlyUsed), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    // Mark: -
    
    func setData(_ data: Data, forKey key: String) {
        if capacity == 0 || storageIndex.count < capacity {
            storage[key] = data
            storageIndex.add(key)
            
        } else {
            purgeLeastRecentlyUsed()
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
    
    func removeAll() {
        while storageIndex.count > 0 {
            purgeLeastRecentlyUsed()
        }
    }
    
    @objc func purgeLeastRecentlyUsed() {
        if let lastObject = storageIndex.firstObject as? String {
            removeData(forKey: lastObject)
        }
    }
}
