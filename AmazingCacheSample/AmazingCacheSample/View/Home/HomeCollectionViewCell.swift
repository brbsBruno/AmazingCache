//
//  HomeCollectionViewCell.swift
//  AmazingCacheSample
//
//  Created by Bruno Barbosa on 21/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit
import AmazingCache

let HomeCollectionViewCellReuseIdentifier = "HomeCell"

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        mainImageView.layer.cornerRadius = 5
        mainImageView.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = 25
        mainImageView.layer.masksToBounds = true
    }
    
    var cardInfo: Card? {
        didSet {
            if let cardInfo = cardInfo {
                
                if let urlString = cardInfo.thumbUrl,
                    let url = URL(string: urlString) {
                    
                    AmazingCache().loadData(url: url) { (result) in
                        switch result {
                        case .success(let data):
                            self.mainImageView.image = UIImage(data: data)
                        case .failure( _):
                            break
                        }
                    }
                }
                
                //userNameLabel.text = cardInfo.id
            }
        }
    }
}
