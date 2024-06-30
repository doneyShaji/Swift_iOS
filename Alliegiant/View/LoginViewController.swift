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
        
        if UserManager.shared.isLoggedIn() {
                    navigateToMainTabBarController()
        }
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
        if UserManager.shared.login(email: email, password: password) {
                    navigateToMainTabBarController()
                } else {
                    showAlert(message: "Invalid email or password.")
                }
    }
    func navigateToMainTabBarController() {
            if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                tabBarController.modalPresentationStyle = .fullScreen
                present(tabBarController, animated: true, completion: nil)
            }
        }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let myAccountVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? MyAccountViewController {
                    self.navigationController?.pushViewController(myAccountVC, animated: true)
                }
    }
}

extension LoginViewController {
    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 5
    }
}

