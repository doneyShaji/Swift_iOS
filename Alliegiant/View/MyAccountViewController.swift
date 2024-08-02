//
//  MyAccountViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit
import CoreData
import FirebaseAuth

class MyAccountViewController: UIViewController {
    
    var onNameUpdate: ((String) -> Void)?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var lastNameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    
    @IBOutlet weak var editFirstNameTextField: UITextField!
    @IBOutlet weak var editLastNameTextField: UITextField!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editPhoneNumber: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    var notLoggedInLabel: UILabel!
    var loginButton: UIButton!
    
    var isEditingMode = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIAccount()
        
        if Auth.auth().currentUser == nil {
            showNotLoggedInUI()
        } else {
            loadUserDetails()
            toggleEditingMode(false)
        }
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
        
        // Initialize notLoggedInLabel and loginButton
        notLoggedInLabel = UILabel()
        notLoggedInLabel.text = "You are not logged in."
        notLoggedInLabel.textAlignment = .center
        notLoggedInLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(navigateToLoginViewController), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
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
    @IBAction func moreButtonClicked(_ sender: Any) {
        let menuViewController = MenuViewController()
        menuViewController.modalPresentationStyle = .pageSheet
        if let sheet = menuViewController.sheetPresentationController {
            // Custom detent
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 300 // The height you want for the view controller
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        present(menuViewController, animated: true)
        
        
        
    }
    // MARK: - Show Not Logged In UI
    func showNotLoggedInUI() {
        view.addSubview(notLoggedInLabel)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            notLoggedInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notLoggedInLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: notLoggedInLabel.bottomAnchor, constant: 10)
        ])
        
        // Hide other UI elements
        profileImageView.isHidden = true
        firstNameLabel.isHidden = true
        lastNameLabel.isHidden = true
        emailLabel.isHidden = true
        phoneNumberLabel.isHidden = true
        editFirstNameTextField.isHidden = true
        editLastNameTextField.isHidden = true
        editEmailTextField.isHidden = true
        editPhoneNumber.isHidden = true
        editButton.isHidden = true
        logoutButton.isHidden = true
        firstNameTitle.isHidden = true
        lastNameTitle.isHidden = true
        emailTitle.isHidden = true
        phoneTitle.isHidden = true
        menuBtn.isHidden = true
    }
    // MARK: - Load User Details
    func loadUserDetails() {
        if let user = Auth.auth().currentUser {
            firstNameLabel.text = user.displayName ?? "N/A"
            lastNameLabel.text = user.displayName ?? "N/A" // Adjust this based on how you store the last name
            emailLabel.text = user.email ?? "N/A"
            phoneNumberLabel.text = user.phoneNumber ?? "N/A"
            
            editFirstNameTextField.text = user.displayName
            editLastNameTextField.text = user.displayName // Adjust this based on how you store the last name
            editEmailTextField.text = user.email
            editPhoneNumber.text = user.phoneNumber
            
            if let photoURL = user.photoURL {
                loadProfileImage(from: photoURL)
            }
        } else {
            showNotLoggedInUI()
        }
    }
    func loadProfileImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image data")
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }
        task.resume()
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
            // Update user details in Firebase
            guard let firstName = editFirstNameTextField.text, !firstName.isEmpty,
                  let lastName = editLastNameTextField.text, !lastName.isEmpty,
                  let email = editEmailTextField.text, email.isValidEmail,
                  let phoneNumber = editPhoneNumber.text, !phoneNumber.isEmpty else {
                showAlert(message: "Please make sure all fields are filled correctly.")
                return
            }
            
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = "\(firstName) \(lastName)" // Adjust based on how you want to store first and last name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Failed to update user details:", error.localizedDescription)
                        self.showAlert(message: "Failed to update details: \(error.localizedDescription)")
                    } else {
                        self.showAlert(message: "Details updated successfully!") { [weak self] in
                            self?.isEditingMode = false
                            self?.toggleEditingMode(false)
                            self?.loadUserDetails()
                        }
                    }
                }
            }
        } else {
            do {
                try Auth.auth().signOut()
                navigateToLoginViewController()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
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
    
    @objc func navigateToLoginViewController() {
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
