//
//  OrdersViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/08/24.
//

import UIKit
import FirebaseAuth
import CoreData
class OrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Order]?
    
        var notLoggedInLabel: UILabel!
        var loginButton: UIButton!
        var noOrdersLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
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
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController {
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = loginNavController
                    window.makeKeyAndVisible()
                }, completion: { _ in
                    // Log the order of the view controllers in the navigation stack
                    print("Current Navigation Stack: \(loginNavController.viewControllers)")
                })
            }
        }
    }

    extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
            let order = items?[indexPath.row]
            
            cell.textLabel?.text = "Order ID: \(order?.orderID?.uuidString ?? "")"
            cell.detailTextLabel?.text = "Total: \(order?.totalAmount ?? 0.0)"
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
