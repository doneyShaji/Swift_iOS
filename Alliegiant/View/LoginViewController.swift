//
//  LoginViewController.swift
//  Alliegiant
//
//  Created by P10 on 12/06/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, email.isValidEmail else {
            showAlert(message: "Invalid email address.")
            return
        }
        
        guard let password = passwordTextField.text, isPasswordValid(password) else {
            showAlert(message: "Password must be at least 5 characters long.")
            return
        }
        if let userData = UserDefaults.standard.data(forKey: "userDetails"),
           let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String],
           let savedEmail = userDetails["email"], savedEmail == email,
           let savedPassword = userDetails["password"], savedPassword == password {
            print(userDetails)
            // Save user credentials
            UserDefaults.standard.set(savedEmail, forKey: "userEmail")
            UserDefaults.standard.set(savedPassword, forKey: "userPassword")
            // Navigate to the tab controller view
            if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                tabBarController.modalPresentationStyle = .fullScreen
                present(tabBarController, animated: true, completion: nil)
            }
        } else {
            showAlert(message: "Invalid email or password.")
        }
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 5
    }
}

