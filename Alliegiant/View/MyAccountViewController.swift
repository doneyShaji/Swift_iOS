//
//  MyAccountViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var editFirstNameTextField: UITextField!
    @IBOutlet weak var editLastNameTextField: UITextField!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editPhoneNumber: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var isEditingMode = false
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadUserDetails()
            toggleEditingMode(false)
        }
    
    
    //SHOW USER DETAILS
    func loadUserDetails() {
            if let userData = UserDefaults.standard.data(forKey: "userDetails"),
               let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String] {
               
               firstNameLabel.text = userDetails["firstName"]
               lastNameLabel.text = userDetails["lastName"]
               emailLabel.text = userDetails["email"]
               phoneNumberLabel.text = userDetails["phoneNumber"]
               
               editFirstNameTextField.text = userDetails["firstName"]
               editLastNameTextField.text = userDetails["lastName"]
               editEmailTextField.text = userDetails["email"]
               editPhoneNumber.text = userDetails["phoneNumber"]
           }
        }
    
    func toggleEditingMode(_ enable: Bool) {
            editFirstNameTextField.isHidden = !enable
            editLastNameTextField.isHidden = !enable
            editEmailTextField.isHidden = !enable
            editPhoneNumber.isHidden = !enable
            
            firstNameLabel.isHidden = enable
            lastNameLabel.isHidden = enable
            emailLabel.isHidden = enable
            phoneNumberLabel.isHidden = enable
            
            logoutButton.setTitle(enable ? "Update" : "Logout", for: .normal)
        }
    
    @IBAction func editButtonTapped(_ sender: Any) {
            isEditingMode.toggle()
            toggleEditingMode(isEditingMode)
        }
        
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        if isEditingMode {
                    guard let firstName = editFirstNameTextField.text, !firstName.isEmpty,
                          let lastName = editLastNameTextField.text, !lastName.isEmpty,
                          let email = editEmailTextField.text, email.isValidEmail,
                          let phoneNumber = editPhoneNumber.text, !phoneNumber.isEmpty else {
                        showAlert(message: "Please make sure all fields are filled correctly.")
                        return
                    }
                    
                    let userDetails = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "phoneNumber": phoneNumber
                    ]
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: userDetails, options: [])
                        UserDefaults.standard.set(jsonData, forKey: "userDetails")
                        showAlert(message: "Details updated successfully!") {
                            self.isEditingMode = false
                            self.toggleEditingMode(false)
                            self.loadUserDetails()
                        }
                    } catch {
                        showAlert(message: "Failed to update user details.")
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: "userDetails")
                    print("User details have been removed.")
                    if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                        loginViewController.modalPresentationStyle = .fullScreen
                        present(loginViewController, animated: true, completion: nil)
                    }
                }
    }
    
        func showAlert(message: String, completion: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
            present(alert, animated: true, completion: nil)
        }
    
}
