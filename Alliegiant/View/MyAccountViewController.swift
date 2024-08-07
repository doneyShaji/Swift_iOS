//
//  MyAccountViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit
import CoreData
import FirebaseAuth

class MyAccountViewController: UIViewController, LoginViewControllerDelegate {
    
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var nameMainTitle: UILabel!
    //Acount Details View
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var accountDetailsView: UIView!
    
    //Edit View
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var nameEditLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailEditLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneEditLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var countryEditLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var genderEditLabel: UILabel!
    @IBOutlet weak var genderTextField: UITextField!
    
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
        profileImageView.layer.masksToBounds = true
        profileImageView.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 4.0
        
        accountDetailsView.layer.borderColor = UIColor.lightGray.cgColor
        accountDetailsView.layer.borderWidth = 1.0
        
        nameTextField.layer.masksToBounds = true
        nameTextField.cornerRadius = 6
        nameTextField.layer.borderColor = UIColor.systemGray6.cgColor
        nameTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.cornerRadius = 6
        emailTextField.layer.borderColor = UIColor.systemGray6.cgColor
        emailTextField.layer.borderWidth = 1.0
        phoneTextField.layer.masksToBounds = true
        phoneTextField.cornerRadius = 6
        phoneTextField.layer.borderColor = UIColor.systemGray6.cgColor
        phoneTextField.layer.borderWidth = 1.0
        countryTextField.layer.masksToBounds = true
        countryTextField.cornerRadius = 6
        countryTextField.layer.borderColor = UIColor.systemGray6.cgColor
        countryTextField.layer.borderWidth = 1.0
        genderTextField.layer.masksToBounds = true
        genderTextField.cornerRadius = 6
        genderTextField.layer.borderColor = UIColor.systemGray6.cgColor
        genderTextField.layer.borderWidth = 1.0
        
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
    
    func loginViewControllerDidLogin(_ controller: LoginViewController) {
        controller.dismiss(animated: true) {
            // Reload the view controller after dismissing the login view controller
            if let navigationController = self.navigationController {
                // Pop the current view controller
                navigationController.popViewController(animated: false)
                
                // Instantiate and push the view controller again
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
                navigationController.pushViewController(newViewController, animated: false)
            }
        }
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
        detailsView.isHidden = true
        editView.isHidden = true
        nameMainTitle.isHidden = true
        bgView.isHidden = true
        editButton.isHidden = true
        profileImageView.isHidden = true
    }
    
    // MARK: - Load User Details
       func loadUserDetails() {
           if let user = Auth.auth().currentUser {
               if let providerData = user.providerData.first {
                   switch providerData.providerID {
                   case "google.com":
                       loadGoogleUserDetails()
                   case "password":
                       loadEmailUserDetails()
                   default:
                       showNotLoggedInUI()
                   }
               }
           } else {
               showNotLoggedInUI()
           }
       }

       func loadGoogleUserDetails() {
           if let user = Auth.auth().currentUser {
               if let photoURL = user.photoURL {
                   loadProfileImage(from: photoURL)
               }
               nameMainTitle.text = user.displayName ?? "N/A"
               emailLabel.text = user.email ?? "N/A"
               phoneLabel.text = user.phoneNumber ?? "N/A"
               countryLabel.text = "India"
               genderLabel.text = "Female"
               if let photoURL = user.photoURL {
                   loadProfileImage(from: photoURL)
               }
           }
       }

       func loadEmailUserDetails() {
//           let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
//
//           do {
//               let results = try context.fetch(fetchRequest)
//               print("Total registered users: \(results.count)")
//               for user in results {
//                   print("UserID: \(user.userID ?? "No ID"), Name: \(user.name ?? "No Name")")
//               }
//           } catch {
//               print("Failed to fetch users: \(error.localizedDescription)")
//           }
           
           let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "userID == %@", Auth.auth().currentUser?.uid ?? "")

           do {
               let results = try context.fetch(fetchRequest)
               if let registeredUser = results.first {
                   if registeredUser.gender == "Female"{
                       profileImageView.image = #imageLiteral(resourceName: "woman_6997660")
                   } else if registeredUser.gender == "Male" {
                       profileImageView.image = #imageLiteral(resourceName: "man_6997676")
                   }
                   nameMainTitle.text = registeredUser.name
                   emailLabel.text = registeredUser.emailAddress
                   phoneLabel.text = String(registeredUser.phoneNo)
                   countryLabel.text = "India"
                   genderLabel.text = registeredUser.gender
               }
           } catch {
               print("Failed to fetch user data from Core Data: \(error.localizedDescription)")
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
            editView.isHidden = !enable
            detailsView.isHidden = enable
            editButton.setTitle(enable ? "Save" : "Edit Profile", for: .normal)
            
            if enable {
                if let user = Auth.auth().currentUser {
                    nameTextField.text = user.displayName ?? ""
                    emailTextField.text = user.email ?? ""
                    phoneTextField.text = user.phoneNumber ?? ""
                    countryTextField.text = "India"
                    genderTextField.text = "Female"
                }
            }
        }
        
        @IBAction func editButtonTapped(_ sender: Any) {
            isEditingMode.toggle()
            toggleEditingMode(isEditingMode)
            if !isEditingMode {
                updateDetails()
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the name of your storyboard if different
            if let loginNavController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController {
                if let loginVC = loginNavController.viewControllers.first as? LoginViewController {
                    loginVC.delegate = self
                }
                loginNavController.modalPresentationStyle = .fullScreen
                present(loginNavController, animated: true, completion: nil)
            }
        }
        
        func updateDetails() {
            guard let email = emailTextField.text, !email.isEmpty,
                  let name = nameTextField.text, !name.isEmpty,
                  let phone = phoneTextField.text, !phone.isEmpty,
                  let country = countryTextField.text, !country.isEmpty,
                  let gender = genderTextField.text, !gender.isEmpty else {
                showAlert(message: "Please make sure all fields are filled correctly.")
                return
            }
            
            if let user = Auth.auth().currentUser {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Failed to update user details:", error.localizedDescription)
                        self.showAlert(message: "Failed to update details: \(error.localizedDescription)")
                    } else {
                        self.showAlert(message: "Details updated successfully!") { [weak self] in
                            self?.loadUserDetails()
                        }
                    }
                }
            }
        }
    }

