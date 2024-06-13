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
        
               // Print email and password to the console
               print("Email: \(email)")
               print("Password: \(password)")
               
               // Save email and password using UserDefaults
               UserDefaults.standard.set(email, forKey: "userEmail")
               UserDefaults.standard.set(password, forKey: "userPassword")
               
               // Navigate to the tab controller view
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
    }
extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension LoginViewController {
    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 5
    }
}

