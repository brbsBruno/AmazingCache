//
//  HomeViewModel.swift
//  AmazingCacheSample
//
//  Created by Bruno Barbosa on 20/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import Foundation
import UIKit.NSDataAsset

class HomeViewModel {
    
    func loadCardsAtPage(_ page: Int) -> [Card] {
        
        var cards = [Card]()
        
        if let jsonData = NSDataAsset(name: "DataSource", bundle: Bundle.main),
            let jsonArray = try? JSONSerialization.jsonObject(with: jsonData.data, options: []) as? [Any] {
            
            for case let jsonObject in jsonArray! {
                if let card = Card(json: jsonObject as! [String:Any]) {
                    cards.append(card)
                }
            }
        }
        
        return cards
    }
}
