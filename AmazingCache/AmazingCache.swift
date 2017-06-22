//
//  AmazingCache.swift
//  AmazingCache
//
//  Created by Bruno Barbosa on 17/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum AmazingCacheError: Error {
    case resourceNotFound
}

public class AmazingCache: NSObject {
    
    var cache = MemoryCache.shared
    var rest = BasicRestClient()
    
    public func loadData(url: URL, completionHandler: @escaping (Result<Data>) -> Void) {
        var result: Result<Data>
        
        if let storedData = memoryFetch(key: url.absoluteString) {
            result = Result.success(storedData)
            completionHandler(result)
            
        } else {
            result = Result.failure(AmazingCacheError.resourceNotFound)
            
            let dataResource = Resource<Data>(url: url) { data in
                return data
            }
            
            networkFetch(resource: dataResource, completionHandler: { (data, error) in
                if let data = data {
                    result = Result.success(data)
                    self.memoryStoreData(data, forKey: url.absoluteString)
                    
                } else if let error = error {
                    result = Result.failure(error)
                }
                completionHandler(result)
            })
        }
    }
    
    public func refreshData() {
        cache.removeAll()
    }
    
    // MARK: Private functions
    
    private func memoryFetch(key: String) -> Data? {
        return cache.object(forKey:key)
    }
    
    private func memoryStoreData(_ data: Data, forKey key: String) {
        guard !key.isEmpty else {
            return
        }
        
        cache.setData(data, forKey: key)
    }
    
    private func networkFetch(resource: Resource<Data>, completionHandler:@escaping (Data?, Error?) -> ()) {
        rest.get(resource) { (data, error) in
            completionHandler(data, error)
        }
    }
}
