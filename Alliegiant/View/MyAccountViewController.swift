//
//  MyAccountViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit
import CoreData

class MyAccountViewController: UIViewController {
    
    var onNameUpdate: ((String) -> Void)?
    
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDetails()
        toggleEditingMode(false)
        setupUIAccount()
    }
    //MARK: - Button Designs
    func setupUIAccount(){
        editButton.configuration = .tinted()
        editButton.configuration?.title = "Edit"
        editButton.configuration?.image = UIImage(systemName: "square.and.pencil.circle")
        editButton.configuration?.imagePadding = 8
        editButton.configuration?.baseForegroundColor = .systemPink
        editButton.configuration?.baseBackgroundColor = .systemPink
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        logoutButton.configuration = .tinted()
        logoutButton.configuration?.title = "Logout"
        logoutButton.configuration?.image = UIImage(systemName: "person.crop.circle.badge.minus")
        logoutButton.configuration?.imagePadding = 8
        logoutButton.configuration?.baseForegroundColor = .systemPink
        logoutButton.configuration?.baseBackgroundColor = .systemPink
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    //MARK: - Hamburger Menu
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    var menuOut = false
    @IBAction func hamburgerMenuClicked(_ sender: Any) {
        
        if menuOut == false {
            leading.constant = -150
            trailing.constant = 150
            menuOut = true
        } else {
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        
        // Animate the constraint changes
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Show User Details
    func loadUserDetails() {
        // Fetch the logged-in user's details from Core Data
        let request: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                firstNameLabel.text = user.firstName
                lastNameLabel.text = user.lastName
                emailLabel.text = user.emailAddress
                phoneNumberLabel.text = String(user.phoneNo)
                
                editFirstNameTextField.text = user.firstName
                editLastNameTextField.text = user.lastName
                editEmailTextField.text = user.emailAddress
                editPhoneNumber.text = String(user.phoneNo)
            }
        } catch {
            print("Failed to fetch user details:", error.localizedDescription)
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
        editButton.setTitle(enable ? "Cancel Editing" : "Edit", for: .normal)
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        isEditingMode.toggle()
        toggleEditingMode(isEditingMode)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        if isEditingMode {
            // Update user details in Core Data
            guard let firstName = editFirstNameTextField.text, !firstName.isEmpty,
                  let lastName = editLastNameTextField.text, !lastName.isEmpty,
                  let email = editEmailTextField.text, email.isValidEmail,
                  let phoneNumber = editPhoneNumber.text, let phoneNo = Int64(phoneNumber) else {
                showAlert(message: "Please make sure all fields are filled correctly.")
                return
            }
            
            let request: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
            do {
                let users = try context.fetch(request)
                if let user = users.first {
                    user.firstName = firstName
                    user.lastName = lastName
                    user.emailAddress = email
                    user.phoneNo = phoneNo
                    try context.save()
                    showAlert(message: "Details updated successfully!") { [weak self] in
                        self?.isEditingMode = false
                        self?.toggleEditingMode(false)
                        self?.loadUserDetails()
                    }
                }
            } catch {
                print("Failed to update user details:", error.localizedDescription)
            }
        } else {
            UserManager.shared.logout()
            navigateToLoginViewController()
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
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func didUpdateDetails(name: String) {
        loadUserDetails()
    }
}
