//
//  HomeCollectionViewController.swift
//  AmazingCacheSample
//
//  Created by Bruno Barbosa on 20/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit
import AmazingCache

class HomeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    private var cards = [Card]()
    private var viewModel = HomeViewModel()
    
    var itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            itemsPerRow = 3
        }
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        collectionViewFlowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        collectionViewFlowLayout.minimumLineSpacing = sectionInsets.left
        collectionViewFlowLayout.minimumInteritemSpacing = sectionInsets.left
        
        cards = viewModel.loadCardsAtPage(0)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            cards += viewModel.loadCardsAtPage(0)
            collectionView!.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.red
        cell.cardInfo = cards[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
