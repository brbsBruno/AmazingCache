//
//  ViewController.swift
//  AmazingCacheSample
//
//  Created by Bruno Barbosa on 18/06/17.
//  Copyright © 2017 Bruno Barbosa. All rights reserved.
//

import UIKit
import AmazingCache

class HomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let urlString = "https://i.imgur.com/pcENhyi.jpg"
        let url = URL(string: urlString)!
        
        AmazingCache().loadData(url: url) { (result) in
            switch result {
                
            case .success(let data):
                
                    self.imageView.image = UIImage(data: data)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func showDetailViewController(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}

