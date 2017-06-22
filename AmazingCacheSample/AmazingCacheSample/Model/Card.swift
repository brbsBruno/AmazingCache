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
    var user: User?
    var createdAt: String?
    
    struct User {
        var name: String?
        var profileImage: ProfileImage?
        
        struct ProfileImage {
            var small: String?
            var medium: String?
            
            init?(json: [String: Any]) {
                guard let small = json["small"] as? String,
                    let medium = json["medium"] as? String else {
                        return nil
                }
                
                self.small = small
                self.medium = medium
            }
        }
        
        init?(json: [String: Any]) {
            guard let name = json["name"] as? String,
                let profileImageJSON = json["profile_image"] as? [String : String] else {
                    return nil
            }
            
            self.name = name
            self.profileImage = ProfileImage.init(json: profileImageJSON)
        }
    }
}

extension Card {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let width = json["width"] as? Double,
            let height = json["height"] as? Double,
            let user = json["user"] as? [String : Any],
            let createdAt = json["created_at"] as? String,
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
        self.user = User.init(json: user)
        self.createdAt = createdAt
    }
}
