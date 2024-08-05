//
//  OrdersViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/08/24.
//

import UIKit
import FirebaseAuth
import CoreData
class OrdersViewController: UIViewController, LoginViewControllerDelegate, UINavigationControllerDelegate {
    func loginViewControllerDidLogin(_ controller: LoginViewController) {
        controller.dismiss(animated: true) {
            // Reload the view controller after dismissing the login view controller
            if let navigationController = self.navigationController {
                // Pop the current view controller
                navigationController.popViewController(animated: false)
                
                // Instantiate and push the view controller again
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
                navigationController.pushViewController(newViewController, animated: false)
            }
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Order]?
    
    var notLoggedInLabel: UILabel!
    var loginButton: UIButton!
    var noOrdersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order History"
        setupUI()
        items = []
        fetchOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the tab bar
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupUI() {
        // Not Logged In Label
        notLoggedInLabel = UILabel()
        notLoggedInLabel.text = "You are not logged in to view history."
        notLoggedInLabel.textAlignment = .center
        notLoggedInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Login Button
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(navigateToLoginViewController), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // No Orders Label
        noOrdersLabel = UILabel()
        noOrdersLabel.text = "No orders placed yet."
        noOrdersLabel.textAlignment = .center
        noOrdersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(notLoggedInLabel)
        view.addSubview(loginButton)
        view.addSubview(noOrdersLabel)
        
        NSLayoutConstraint.activate([
            notLoggedInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notLoggedInLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: notLoggedInLabel.bottomAnchor, constant: 10),
            
            noOrdersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noOrdersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        notLoggedInLabel.isHidden = true
        loginButton.isHidden = true
        noOrdersLabel.isHidden = true
    }
    
    func fetchOrders() {
        if Auth.auth().currentUser == nil {
            showNotLoggedInUI()
        } else {
            do {
                self.items = try context.fetch(Order.fetchRequest())
                tableView.reloadData()
                if items?.isEmpty ?? true {
                    showNoOrdersUI()
                } else {
                    hideNotLoggedInUI()
                }
            } catch {
                print("Failed to fetch orders: \(error)")
            }
        }
    }
    
    func showNotLoggedInUI() {
        notLoggedInLabel.isHidden = false
        loginButton.isHidden = false
        noOrdersLabel.isHidden = true
        tableView.isHidden = true
    }
    
    func hideNotLoggedInUI() {
        notLoggedInLabel.isHidden = true
        loginButton.isHidden = true
        noOrdersLabel.isHidden = true
        tableView.isHidden = false
    }
    
    func showNoOrdersUI() {
        notLoggedInLabel.isHidden = true
        loginButton.isHidden = true
        noOrdersLabel.isHidden = false
        tableView.isHidden = true
    }
    
    @objc func navigateToLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the name of your storyboard if different
        if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController {
            if let loginVC = loginNavController.viewControllers.first as? LoginViewController {
                loginVC.delegate = self
            }
            loginNavController.modalPresentationStyle = .fullScreen
            present(loginNavController, animated: true, completion: nil)
        }
    }
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrdersTableViewCell else {
            return UITableViewCell()
        }
        let order = items?[indexPath.row]
        cell.orderID.text = order?.orderID?.uuidString ?? " "
        if let totalAmount = order?.totalAmount {
            cell.orderTotal.text = String(totalAmount)
            
        }
        
        else {
            cell.orderTotal.text = "0.00"
        }
        if let date = order?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            cell.orderDate.text = dateFormatter.string(from: date)
        } else {
            cell.orderDate.text = "N/A"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = items?[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let orderDetailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
            orderDetailVC.order = selectedOrder
            navigationController?.pushViewController(orderDetailVC, animated: true)
        }
    }
}
