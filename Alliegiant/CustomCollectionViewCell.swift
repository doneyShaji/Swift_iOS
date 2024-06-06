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
    
    func setup(with colour: Colours) {
        titleLabel.text = colour.title
    }
}

