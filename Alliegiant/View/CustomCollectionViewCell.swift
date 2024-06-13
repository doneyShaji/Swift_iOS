////
////  CustomCollectionViewCell.swift
////  Alliegiant
////
////  Created by P10 on 04/06/24.
////
//
//import UIKit
//
//class CustomCollectionViewCell: UICollectionViewCell {
//    
//    
//    @IBOutlet weak var collectionViewLabel: UILabel!
//    
//    func setup(with colour: Colours){
//        collectionViewLabel.text = colour.title
//    }
//}
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var collectionImage: UIImageView!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
 
    
    func setup(with colour: Colours) {
        titleLabel.text = colour.title
        descriptionLabel.text = colour.description
        
        // Load the image
        ImageLoader.loadImage(from: colour.thumbnail) { [weak self] image in
                self?.thumbnailImageView.image = image // Assign the image to the imageView's image property
        }
    }
    
}
