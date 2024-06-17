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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
                      let lastName = lastNameTextField.text, !lastName.isEmpty,
                      let email = emailAddressTextField.text, email.isValidEmail,
                      let password = passwordTextField.text, isPasswordValid(password),
              let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
            showAlert(message: "Please make sure all fields are filled correctly and passwords match.")
            return
        }
        
        let userDetails = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "password": password
                ]
        do {
                   let jsonData = try JSONSerialization.data(withJSONObject: userDetails, options: [])
                   UserDefaults.standard.set(jsonData, forKey: "userDetails")
               } catch {
                   showAlert(message: "Failed to save user details.")
                   return
               }

               // Show success message and navigate back to the login page
               showAlert(message: "Registration successful!", completion: {
                   self.dismiss(animated: true, completion: nil)
               })
           }

            func showAlert(message: String, completion: (() -> Void)? = nil) {
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                }))
                present(alert, animated: true, completion: nil)
            }
                
            func isPasswordValid(_ password: String) -> Bool {
                return password.count >= 5
            }
        }

        extension String {
            var isValidEmail: Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: self)
            }
        }
