//
//  CartViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//
// CartViewController.swift
import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartTableView: UITableView!
    var emptyCartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        
        
        // Initialize and configure the empty cart label
                emptyCartLabel = UILabel()
                emptyCartLabel.translatesAutoresizingMaskIntoConstraints = false
                emptyCartLabel.text = "Your cart is empty."
                emptyCartLabel.textAlignment = .center
                emptyCartLabel.font = UIFont.systemFont(ofSize: 20)
                emptyCartLabel.textColor = .gray
                view.addSubview(emptyCartLabel)
                
                // Constraint setup for empty cart label
                NSLayoutConstraint.activate([
                    emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
                
                // Initially hide the table view and show the empty cart message
                cartTableView.isHidden = true
                emptyCartLabel.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
        
        // Show or hide table view and empty cart message based on cart items
                if CartManager.shared.items.isEmpty {
                    cartTableView.isHidden = true
                    emptyCartLabel.isHidden = false
                } else {
                    cartTableView.isHidden = false
                    emptyCartLabel.isHidden = true
                }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartCell = cartTableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartTableViewCell
        let item = CartManager.shared.items[indexPath.row]
        cartCell.cartTitle.text = item.name
        cartCell.cartQuantity.text = "Quantity - \(String(item.quantity))"
        
        // Load the image asynchronously
        ImageLoader.loadImage(from: item.image) { image in
            cartCell.cartImage.image = image
        }
        
        return cartCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 157.0
        }
}

