//
//  Card.swift
//  AmazingCacheSample
//
//  Created by Bruno Barbosa on 20/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import Foundation

struct Card {
    var id: String
    var width: Double
    var height: Double
    var thumbUrl: String?
}

extension Card {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let width = json["width"] as? Double,
            let height = json["height"] as? Double,
            let urlsJSON = json["urls"] as? [String : String] else {
                return nil
        }
        
        for (type, url) in urlsJSON {
            if type == "thumb" {
                self.thumbUrl = url
            }
        }
        
        self.id = id
        self.width = width
        self.height = height
    }
}
