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
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    var collectionLabel: String?
    var collectionImage: String?
    var collectionDescription: String?
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionDetailVC.text = collectionLabel
        collectionViewDescription.text = collectionDescription
        quantityLabel.text = "\(quantity)"
        //        loadImage(from: colour.thumbnail)
        print(collectionImage ?? "No image URL provided")
        
        // Load the image if collectionImage contains a valid URL string
        if let imageUrlString = collectionImage {
                    ImageLoader.loadImage(from: imageUrlString) { [weak self] image in
                        self?.collectionViewDetailImage.image = image
                    }
        }
    }
    
    @IBAction func incrementQuantity(_ sender: Any) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
    }
    @IBAction func decrementQuantity(_ sender: Any) {
        if quantity > 1 {
                    quantity -= 1
                    quantityLabel.text = "\(quantity)"
                }
    }
    @IBAction func addToCart(_ sender: Any) {
        let newItem = CartItem(name: collectionLabel ?? "Unknown", image: collectionImage ?? "", description: collectionDescription ?? "", quantity: quantity)
                CartManager.shared.add(item: newItem)

                // Show success message
                let alertController = UIAlertController(title: "Success", message: "Item successfully added to cart.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
    }
}
