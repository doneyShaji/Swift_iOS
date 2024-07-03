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
    @IBOutlet weak var checkOutBtn: UIButton!
    
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
        
        // Set up the checkout button
        setupCheckoutButton()
        
        // Initially hide the table view and show the empty cart message
        updateCartView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartTableView.reloadData()
        updateCartView()
    }
    
    func updateCartView() {
        if CartManager.shared.items.isEmpty {
            cartTableView.isHidden = true
            emptyCartLabel.isHidden = false
            checkOutBtn.isHidden = true  // Hide the button if the cart is empty
        } else {
            cartTableView.isHidden = false
            emptyCartLabel.isHidden = true
            checkOutBtn.isHidden = false  // Show the button if there are items
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
    // Setup the checkout button
        private func setupCheckoutButton() {
            
            checkOutBtn.configuration = .tinted()
            checkOutBtn.configuration?.title = "Checkout"
            checkOutBtn.configuration?.image = UIImage(systemName: "creditcard")
            checkOutBtn.configuration?.imagePadding = 8
            checkOutBtn.configuration?.baseForegroundColor = .systemIndigo
            checkOutBtn.configuration?.baseBackgroundColor = .systemIndigo
            checkOutBtn.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        }
        
        // Action method for checkout button
        @objc private func checkoutButtonTapped() {
            let alert = UIAlertController(title: "Success", message: "Successfully checked out!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        CartManager.shared.clearCart()
                        self.updateCartView()
                        self.cartTableView.reloadData()
                    })
                    present(alert, animated: true, completion: nil)
                }
}

