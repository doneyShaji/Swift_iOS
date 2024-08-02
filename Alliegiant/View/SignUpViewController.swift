//
//  SignUpViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit
import FirebaseAuth
import CoreData


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    var registeredUsersItems:[RegisteredUsers]?
    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorMessages()
        textFieldDelegates()
        firstNameTextField.placeholder = "Enter your text"
        
    }
    
    func textFieldDelegates(){
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailAddressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.firstNameTextField:
            self.lastNameTextField.becomeFirstResponder()
        case self.lastNameTextField:
            self.emailAddressTextField.becomeFirstResponder()
        case self.emailAddressTextField:
            self.phoneNumberTextField.becomeFirstResponder()
        case self.phoneNumberTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
        default:
            self.confirmPasswordTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameErrorLabel.text = ""
        case lastNameTextField:
            lastNameErrorLabel.text = ""
        case emailAddressTextField:
            emailErrorLabel.text = ""
        case phoneNumberTextField:
            phoneErrorLabel.text = ""
        case passwordTextField:
            passwordErrorLabel.text = ""
        case confirmPasswordTextField:
            confirmPasswordErrorLabel.text = ""
        default:
            break
        }
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        clearErrorMessages()
                
                guard let firstName = firstNameTextField.text, firstName.isNameValid else {
                    firstNameErrorLabel.text = "First name is Invalid."
                    return
                }
                
                guard let lastName = lastNameTextField.text, lastName.isNameValid else {
                    lastNameErrorLabel.text = "Last name is Invalid."
                    return
                }
                
                guard let email = emailAddressTextField.text, email.isValidEmail else {
                    emailErrorLabel.text = "Email is Invalid."
                    return
                }
                
                guard let phone = phoneNumberTextField.text, phone.isTenDigits else {
                    phoneErrorLabel.text = "Phone Number is Invalid."
                    return
                }
                
                guard let password = passwordTextField.text, password.isValidPassword else {
                    passwordErrorLabel.text = "Password must be at least 8 characters long."
                    return
                }
                
                guard let confirmPassword = confirmPasswordTextField.text, confirmPassword == password else {
                    confirmPasswordErrorLabel.text = "Passwords do not match."
                    return
                }
        let userFirebaseID = Auth.auth().currentUser?.uid
        let user = User(userID: userFirebaseID ?? "", firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, password: password)
                
                UserManager.shared.register(user: user) { success, error in
                    if success {
                        self.showAlert(title: "Success", message: "User registered successfully.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.showAlert(title: "Error", message: error ?? "Registration failed.")
                    }
                }
            }
            
            func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                }))
                present(alert, animated: true, completion: nil)
            }
    
    func clearErrorMessages() {
        firstNameErrorLabel.text = ""
        lastNameErrorLabel.text = ""
        emailErrorLabel.text = ""
        phoneErrorLabel.text = ""
        passwordErrorLabel.text = ""
        confirmPasswordErrorLabel.text = ""
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "You have successfully registered!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigateToLoginViewController()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navigateToLoginViewController() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.popToViewController(loginVC, animated: true)
        }
    }
}
