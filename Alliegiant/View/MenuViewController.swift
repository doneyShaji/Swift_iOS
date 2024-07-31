//
//  MenuViewController.swift
//  Alliegiant
//
//  Created by P10 on 26/06/24.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {
    
    let ordersButton = UIButton()
    let paymentsButton = UIButton()
    let addressButton = UIButton()
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIMenu()
    }
    
    func setupUIMenu() {
        view.addSubview(ordersButton)
        view.addSubview(paymentsButton)
        view.addSubview(addressButton)
        view.addSubview(logoutButton)
        view.backgroundColor = .systemBackground
        
        [ordersButton, paymentsButton, addressButton, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        setupButton(ordersButton, title: "Your Orders", image: "bag")
        setupButton(paymentsButton, title: "Payments", image: "creditcard")
        setupButton(addressButton, title: "Address", image: "location")
        setupLogoutButton()
        
        NSLayoutConstraint.activate([
            ordersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ordersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            ordersButton.heightAnchor.constraint(equalToConstant: 50),
            ordersButton.widthAnchor.constraint(equalToConstant: 280),
            
            paymentsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentsButton.topAnchor.constraint(equalTo: ordersButton.bottomAnchor, constant: 20),
            paymentsButton.heightAnchor.constraint(equalToConstant: 50),
            paymentsButton.widthAnchor.constraint(equalToConstant: 280),
            
            addressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressButton.topAnchor.constraint(equalTo: paymentsButton.bottomAnchor, constant: 20),
            addressButton.heightAnchor.constraint(equalToConstant: 50),
            addressButton.widthAnchor.constraint(equalToConstant: 280),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: 10),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupButton(_ button: UIButton, title: String, image: String) {
        button.configuration = .tinted()
        button.configuration?.title = title
        button.configuration?.image = UIImage(systemName: image)
        button.configuration?.imagePadding = 8
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseForegroundColor = .systemBlue
        button.configuration?.baseBackgroundColor = .systemBlue
    }
    
    func setupLogoutButton() {
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(.systemBlue, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        switch sender {
        case ordersButton:
            print("Orders button tapped")
            // Navigate to the Orders screen
        case paymentsButton:
            print("Payments button tapped")
            // Navigate to the Payments screen
        case addressButton:
            print("Address button tapped")
            // Navigate to the Address screen
        default:
            break
        }
    }
    
    @objc func logoutButtonTapped() {
        print("Logout button tapped")
        do {
            try Auth.auth().signOut()
            navigateToLoginViewController()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToLoginViewController() {
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
