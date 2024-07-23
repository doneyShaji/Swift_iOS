//
//  CartViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//
// CartViewController.swift
import UIKit
import Razorpay

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartItemCellDelegate {
    
    let razorPayKey = "rzp_test_rpBn8AgkrcNdDH"
    var razorPay : RazorpayCheckout? = nil
    var merchantDetails: MerchantDetails = MerchantDetails.getDefaultData()
    
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
        self.tabBarController?.tabBar.isHidden = true
        cartTableView.reloadData()
        updateCartView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
        cartCell.cartPrice.text = item.price
        cartCell.cartQuantity.text = "Quantity - \(String(item.quantity))"
        
        // Load the image asynchronously
        ImageLoader.loadImage(from: item.image) { image in
            cartCell.cartImage.image = image
        }
        // Set the delegate
        cartCell.delegate = self
        
        return cartCell
    }
    
    // UITableViewDelegate method for swipe-to-delete
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let item = CartManager.shared.items[indexPath.row]
                CartManager.shared.remove(item: item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                updateCartView()  // Update the view after removing the item
            }
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
        checkOutBtn.configuration?.baseForegroundColor = .systemPink
        checkOutBtn.configuration?.baseBackgroundColor = .systemPink
        checkOutBtn.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    // Action method for checkout button
    @objc private func checkoutButtonTapped() {
        
        openRazorPayCheckOut()
        
        
        
    }
    
    // CartItemCellDelegate method
    func didTapRemoveButton(on cell: CartTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            let item = CartManager.shared.items[indexPath.row]
            CartManager.shared.remove(item: item)
            cartTableView.deleteRows(at: [indexPath], with: .automatic)
            updateCartView()  // Update the view after removing the item
        }
    }
    func clearCartItems(){
        CartManager.shared.clearCart()
        updateCartView()
        cartTableView.reloadData()
    }
    func openRazorPayCheckOut(){
        
        razorPay = RazorpayCheckout.initWithKey(razorPayKey, andDelegate: self)
        let options: [String:Any] = [
            //                    "key": razorPayKey,
            "amount": "5000", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Pay 100 Rupees Now",
            //                    "order_id": "order_DBJOWzybf0sJbb",
            "image": merchantDetails.logo,
            "name": merchantDetails.name,
            "prefill": [
                "contact": "8606725216",
                "email": "a@b.com"
            ],
            "theme": [
                "color": "#336699"
            ]
        ]
        razorPay?.open(options)
    }
    
}

extension CartViewController : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        self.presentAlert(withTitle: "Alert", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
        clearCartItems()
    }
    
    func presentAlert(withTitle title: String?, message: String?){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(OkAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

struct MerchantDetails {
    let name : String
    let logo : String
    let color : UIColor
}

extension MerchantDetails {
    static func getDefaultData() -> MerchantDetails {
        let details = MerchantDetails(name: "iOSPaymentGateway", logo: "https://img.freepik.com/free-vector/bird-colorful-gradient-design-vector_343694-2506.jpg?t=st=1721283674~exp=1721287274~hmac=6dac28cd7217e18721d9b3ca4038ad446101a3f5402786881b65779df1a79417&w=740", color: .red)
        return details
    }
}


