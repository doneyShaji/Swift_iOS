//
//  SignUpViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorMessages()
        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        clearErrorMessages()
                
                guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
                    firstNameErrorLabel.text = "First name is required."
                    return
                }
                
                guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
                    lastNameErrorLabel.text = "Last name is required."
                    return
                }
                
                guard let email = emailAddressTextField.text, email.isValidEmail else {
                    emailErrorLabel.text = "Invalid email address."
                    return
                }
                
                guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
                    phoneErrorLabel.text = "Phone number is required."
                    return
                }
                
                guard let password = passwordTextField.text, isPasswordValid(password) else {
                    passwordErrorLabel.text = "Password must be at least 8 characters long."
                    return
                }
                
                guard let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
                    confirmPasswordErrorLabel.text = "Passwords do not match."
                    return
                }
        
        let newUser = User(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password)
                
                if UserManager.shared.register(user: newUser) {
                    UserManager.shared.login(email: newUser.email, password: newUser.password)
                    showLoginViewController()
                } else {
                    emailErrorLabel.text = "Email already exists."
                }
            }
            
            func clearErrorMessages() {
                firstNameErrorLabel.text = ""
                lastNameErrorLabel.text = ""
                emailErrorLabel.text = ""
                phoneErrorLabel.text = ""
                passwordErrorLabel.text = ""
                confirmPasswordErrorLabel.text = ""
            }
            
            func isPasswordValid(_ password: String) -> Bool {
                return password.count >= 5
            }
            
            func showLoginViewController() {
                if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        }


        extension String {
            var isValidEmail: Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: self)
            }
        }
