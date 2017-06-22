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
    @IBOutlet weak var createdAtLabel: UILabel!
    
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
                
                if let profileUrlString = cardInfo.user?.profileImage?.medium,
                    let profileUrl = URL(string: profileUrlString) {
                    
                    AmazingCache().loadData(url: profileUrl) { (result) in
                        switch result {
                        case .success(let data):
                            self.profileImageView.image = UIImage(data: data)
                        case .failure( _):
                            break
                        }
                    }
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
                
                if let createAt = cardInfo.createdAt,
                    let createDate = dateFormatter.date(from: createAt) {
                    
                    let dateString = DateFormatter.localizedString(from: createDate, dateStyle: .short, timeStyle: .short)
                    
                    createdAtLabel.text = dateString
                }
                
                configureAppearance()
                userNameLabel.text = cardInfo.user?.name
            }
        }
    }
    
    func configureAppearance() {
        mainImageView.layer.cornerRadius = 10
        mainImageView.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = 20
        mainImageView.layer.masksToBounds = true
    }
}
