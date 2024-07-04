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
            
            
            // Set navigation title
            title = "Collection Detail"
                    
            // Add cart button to navigation bar
            let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(addToCartButtonTapped))
            cartButton.tintColor = .systemPink
            navigationItem.rightBarButtonItem = cartButton
            
            // Configure addToCartButton
            addToCartButton.configuration = .tinted()
            addToCartButton.configuration?.title = "Add to Cart"
            addToCartButton.configuration?.image = UIImage(systemName: "cart")
            addToCartButton.configuration?.imagePadding = 8
            addToCartButton.configuration?.baseForegroundColor = .systemPink
            addToCartButton.configuration?.baseBackgroundColor = .systemRed // or any other background color
            addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
                   
            
            collectionDetailVC.text = collectionLabel
            collectionViewDescription.text = collectionDescription
            quantityLabel.text = "\(quantity)"
            print(collectionImage ?? "No image URL provided")
            
            // Load the image if collectionImage contains a valid URL string
            if let imageUrlString = collectionImage {
                ImageLoader.loadImage(from: imageUrlString) { [weak self] image in
                    self?.collectionViewDetailImage.image = image
                }
            }
        }
        @objc func addToCartButtonTapped() {
            guard let cartDetailVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                fatalError("Unable to instantiate CartViewController from storyboard.")
            }
            navigationController?.pushViewController(cartDetailVC, animated: true)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tabBarController?.tabBar.isHidden = true
            // Check if the item is already in the cart and update the quantity
            if let existingItem = CartManager.shared.items.first(where: { $0.name == collectionLabel }) {
                quantity = existingItem.quantity
            } else {
                quantity = 1
            }
            quantityLabel.text = "\(quantity)"
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
