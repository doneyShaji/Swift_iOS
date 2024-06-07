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
    
    
    
    func setup(with colour: Colours) {
        titleLabel.text = colour.title
//        url.text = colour.thumbnail
        loadImage(from: colour.thumbnail)
    }
            
            func loadImage(from urlString: String) {
                guard let url = URL(string: urlString) else {
                    print("Invalid URL string.")
                    return
                }
                
                // Create a URL session data task
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    guard let data = data, let image = UIImage(data: data) else {
                        print("No data or unable to create image from data.")
                        return
                    }
                    
                    // Update UI on the main thread
                    DispatchQueue.main.async {
                        self.thumbnailImageView.image = image
                    }
                }.resume() // Don't forget to resume the task
            }
        }
