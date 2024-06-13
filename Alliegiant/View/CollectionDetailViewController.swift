//
//  CollectionDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 06/06/24.
//

import UIKit

class CollectionDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionDetailVC: UILabel!
    @IBOutlet weak var collectionViewDetailImage: UIImageView!
    @IBOutlet weak var collectionViewDescription: UILabel!
    
    var collectionLabel: String?
    var collectionImage: String?
    var collectionDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionDetailVC.text = collectionLabel
        collectionViewDescription.text = collectionDescription
        //        loadImage(from: colour.thumbnail)
        print(collectionImage ?? "No image URL provided")
        
        // Load the image if collectionImage contains a valid URL string
        if let imageUrlString = collectionImage {
                    ImageLoader.loadImage(from: imageUrlString) { [weak self] image in
                        self?.collectionViewDetailImage.image = image
                    }
        }
    }
}
