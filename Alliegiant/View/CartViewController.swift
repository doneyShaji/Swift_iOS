//
//  CartViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//
// CartViewController.swift
import UIKit
import Razorpay
import FirebaseAuth

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartItemCellDelegate, LoginViewControllerDelegate {
    
    let razorPayKey = "rzp_test_rpBn8AgkrcNdDH"
    var razorPay : RazorpayCheckout? = nil
    var merchantDetails: MerchantDetails = MerchantDetails.getDefaultData()
    var totalAmount: Double = 0.0

    @IBOutlet weak var promoCodeSearchField: UITextField!
    @IBOutlet weak var discountLabel: UILabel!
    
    @IBOutlet weak var discountPercentage: UILabel!
    
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    var emptyCartLabel: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var freeLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        
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
            checkOutBtn.isHidden = true
            AmountLbl.isHidden = true
            shippingLbl.isHidden = true
            freeLbl.isHidden = true
            mrpLbl.isHidden = true
            totalLbl.isHidden = true
            totalAmountLbl.isHidden = true
        } else {
            cartTableView.isHidden = false
            emptyCartLabel.isHidden = true
            checkOutBtn.isHidden = false
            AmountLbl.isHidden = false
            shippingLbl.isHidden = false
            freeLbl.isHidden = false
            mrpLbl.isHidden = false
            totalLbl.isHidden = false
            totalAmountLbl.isHidden = false
            // Calculate the total amount
            let totalAmount = CartManager.shared.items.reduce(0) { $0 + ((Double($1.price) ?? 0) * Double($1.quantity)) }
            let formattedTotalAmount = String(format: "%.2f", totalAmount)
            AmountLbl.text = "$\(formattedTotalAmount)"
            totalAmountLbl.text = "$\(formattedTotalAmount)"
            
        }
    }
    
    @IBAction func promoCodeButtonTapped(_ sender: Any) {
        discountLogic()
    }
    
    func discountLogic(){
        guard let promoCodeText = promoCodeSearchField.text, !promoCodeText.isEmpty else {
            print("Invalid Promo Code")
            return
        }
        applyDiscount(promoCode: promoCodeText)
    }
    
    func applyDiscount(promoCode: String) {
        let discountManager = DiscountManager()
        Task {
            do {
                let promoCode = promoCode
                let promoResponse = try await discountManager.getDiscount(promoCode: promoCode)
                
                if promoResponse.success {
                    if let discount = promoResponse.discount {
                        print("Discount applied:  \(discount)%")
                        discountUIChange(discount: String(discount))
                    }
                } else {
                    print("Failed to apply promo code")
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func discountUIChange(discount: String){
        
        discountLabel.text = "Discount (\(discount)%)"
        
        let totalAmount = CartManager.shared.items.reduce(0) { $0 + ((Double($1.price) ?? 0) * Double($1.quantity)) }
        var percentageAmount: Double {
            return (totalAmount * (Double(discount) ?? 1))/100
        }
        var discountedAmount: Double {
            return Double(totalAmount - percentageAmount)
        }
        
        discountPercentage.text = String(format: "-$%.2f", percentageAmount)
        totalAmountLbl.text = String(format: "$%.2f", discountedAmount)
        print(discountedAmount)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartCell = cartTableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartTableViewCell
        let item = CartManager.shared.items[indexPath.row]
        cartCell.cartTitle.text = item.name
        cartCell.cartPrice.text = "$\(item.price)"
        cartCell.cartQuantity.text = "Quantity: \(String(item.quantity))"
        
        // Load the image asynchronously
        ImageLoader.loadImage(from: item.image) { image in
            cartCell.cartImage.image = image
        }
        
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
  
    private func setupCheckoutButton() {
        checkOutBtn.configuration = .filled()
        checkOutBtn.configuration?.title = "Checkout"
        checkOutBtn.configuration?.image = UIImage(systemName: "creditcard")
        checkOutBtn.configuration?.imagePadding = 8
        checkOutBtn.configuration?.baseForegroundColor = .black
        checkOutBtn.configuration?.baseBackgroundColor = .systemYellow
        checkOutBtn.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    // Action method for checkout button
    @objc private func checkoutButtonTapped() {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the name of your storyboard if different
            if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController {
                if let loginVC = loginNavController.viewControllers.first as? LoginViewController {
                    loginVC.delegate = self
                }
                loginNavController.modalPresentationStyle = .fullScreen
                present(loginNavController, animated: true, completion: nil)
            }
        } else {
            if let userID = Auth.auth().currentUser?.uid{
                CartManager.shared.createOrder(for: userID)
                print("Proceed to checkout")
                openRazorPayCheckOut()
            }
            
        }
    }
    
    func loginViewControllerDidLogin(_ controller: LoginViewController) {
        // Dismiss the login view controller and proceed to checkout
        controller.dismiss(animated: true) {
            self.openRazorPayCheckOut()
        }
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
        let totalAmount = CartManager.shared.items.reduce(0) { $0 + ((Double($1.price) ?? 0) * Double($1.quantity)) }
        razorPay = RazorpayCheckout.initWithKey(razorPayKey, andDelegate: self)
        let options: [String:Any] = [
            //                    "key": razorPayKey,
            "amount": totalAmount * 100, //This is in currency subunits. 100 = 100 paise= INR 1.
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
                "color": "#ffc801"
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
        let details = MerchantDetails(name: "AlligiantSwift", logo: "https://img.freepik.com/free-vector/bird-colorful-gradient-design-vector_343694-2506.jpg?t=st=1721283674~exp=1721287274~hmac=6dac28cd7217e18721d9b3ca4038ad446101a3f5402786881b65779df1a79417&w=740", color: .red)
        return details
    }
}


