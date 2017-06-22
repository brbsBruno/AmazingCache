//
//  RestClient.swift
//  AmazingCache
//
//  Created by Bruno Barbosa on 18/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit

final class BasicRestClient: NSObject {
    
    /**
     https://talk.objc.io/episodes/S01E01-networking
     */
    func get<A>(_ resource: Resource<A>, completion: @escaping (A?, Error?) -> ()) {
        URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main).dataTask(with: resource.url) { data, _, error in
            let result = data.flatMap(resource.decode)
                completion(result, error)
            }.resume()
    }
}

struct Resource<A> {
    let url: URL
    let decode: (Data) -> A?
}
