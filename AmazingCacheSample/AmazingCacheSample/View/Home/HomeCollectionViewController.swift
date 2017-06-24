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
    
    private var animatedCellIndexPaths = [IndexPath]()
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupCollectionViewLayout()
        
        initCards()
    }
    
    // MARK: Setup
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    private func setupCollectionViewLayout() {
        var itemsPerRow: CGFloat = 2
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            itemsPerRow = 3
        }
        
        let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        collectionViewFlowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        collectionViewFlowLayout.minimumLineSpacing = sectionInsets.left
        collectionViewFlowLayout.minimumInteritemSpacing = sectionInsets.left
        
        
        collectionView!.contentInset = UIEdgeInsets(top: 25, left: 5, bottom: 10, right: 5)
    }
    
    private func initCards() {
        cards = viewModel.loadCardsAtPage(0)
        animatedCellIndexPaths = [IndexPath]()
        collectionView?.reloadData()
    }
    
    // MARK: Actions
    
    @objc func refresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        initCards()
    }
    
    fileprivate func loadAnotherPage(_ page: Int) {
        let newCards = viewModel.loadCardsAtPage(page)
        
        var indexPathsForNewCards = [IndexPath]()
        
        for _ in cards.count..<(cards.count + newCards.count) {
            let newIndexPath = IndexPath(row: cards.count, section: 0)
            indexPathsForNewCards.append(newIndexPath)
        }
        
        cards += newCards
        collectionView!.insertItems(at: indexPathsForNewCards)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellReuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.cardInfo = cards[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if !animatedCellIndexPaths.contains(indexPath) {
            cell.alpha = 0
            
            var transform = CATransform3DIdentity
            transform = CATransform3DScale(transform, 0.9, 0.9, 1.0)
            transform = CATransform3DTranslate(transform, 0, 20, 0)
            cell.layer.transform = transform
            
            
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }
            
            animatedCellIndexPaths.append(indexPath)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension HomeCollectionViewController {
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadAnotherPage(0)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { loadAnotherPage(0) }
    }
}
