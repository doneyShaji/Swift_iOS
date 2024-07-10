//
//  SignUpViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
        textFieldDelegates()
        
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
            lastNameErrorLabel.text = "Last name is required."
            return
        }
        
        guard let email = emailAddressTextField.text, email.isValidEmail else {
            emailErrorLabel.text = "Invalid email address."
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.isTenDigits else {
            phoneErrorLabel.text = "Phone number requires 10 digits."
            return
        }
        
        guard let password = passwordTextField.text, password.isValidPassword else {
            passwordErrorLabel.text = "Invalid Password."
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
    
    func showLoginViewController() {
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}

