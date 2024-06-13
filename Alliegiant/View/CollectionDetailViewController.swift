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
                    loadImage(from: imageUrlString)
                }
    }
    
    // Function to load the image from the URL string
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
                self.collectionViewDetailImage.image = image
            }
        }.resume() // resume the task
    }
    
}
