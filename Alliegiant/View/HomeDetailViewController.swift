//
//  HomeDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class HomeDetailViewController: UIViewController{
    
    @IBOutlet var pageImage: UIPageControl!
    var seriesImage: [String] = ["card_1","card_2","card_3","card_4","card_5","card_6"]
    
    
    var titleText: String?
    var images: [String] = []
    var descriptionDetail: String?
    var priceDetail: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionHome: UILabel!
    @IBOutlet weak var priceHome: UILabel!
    @IBOutlet weak var detaillView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detaillView.layer.cornerRadius = 50
        detaillView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        descriptionHome.text = descriptionDetail
        priceHome.text = priceDetail
        
        pageImage.currentPage = 0
        pageImage.numberOfPages = images.count
        
        collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        // Hide the tab bar
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        // Show the tab bar
        tabBarController?.tabBar.isHidden = false
    }
    
    
}

extension HomeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
//        imageCell.imageView.image = UIImage(named: seriesImage[indexPath.row])
        let imageURL = images[indexPath.row]
                ImageLoader.loadImage(from: imageURL) { image in
                    imageCell.imageView.image = image
                }
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageImage.currentPage = indexPath.row
        
    }
}

