//
//  LoginViewController.swift
//  Alliegiant
//
//  Created by P10 on 12/06/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDidLogin(_ controller: LoginViewController)
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerUsersButton: UIButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the user is already logged in
        if Auth.auth().currentUser != nil {
            navigateToMainTabBarController()
        }
        
        // Configure Google Sign-In
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    @IBAction func googleSignInButtonTapped(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                self.showAlert(message: "Google Sign-In failed. \(error!.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.showAlert(message: "Failed to get Google user data.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.showAlert(message: "Firebase authentication failed. \(error.localizedDescription)")
                    return
                }
                if let loggedInGoggleUser = Auth.auth().currentUser {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let newUser = RegisteredUsers(context: context)
                    newUser.firstName = loggedInGoggleUser.displayName
                    newUser.lastName = loggedInGoggleUser.displayName
                    newUser.emailAddress = loggedInGoggleUser.email
                    if let phoneNumberString = loggedInGoggleUser.phoneNumber, let phoneNumberInt = Int64(phoneNumberString) {
                            newUser.phoneNo = phoneNumberInt
                        } else {
                            newUser.phoneNo = 0
                        }
                        
                    newUser.userID = loggedInGoggleUser.uid
                        
                    do{
                        try context.save()
                    } catch {
                        
                    }
                }
                
                self.delegate?.loginViewControllerDidLogin(self)
            }
        }
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, email.isValidEmail else {
            showAlert(message: "Invalid email address.")
            return
        }
        
        guard let password = passwordTextField.text, password.isValidPassword else {
            showAlert(message: "Password must be at least 8 characters long.")
            return
        }
        UserManager.shared.login(email: email, password: password) { [weak self] success, errorMessage in
            guard let self = self else { return }
            
            if success {
                self.delegate?.loginViewControllerDidLogin(self)
            } else {
                self.showAlert(message: errorMessage ?? "Login failed.")
            }
        }            }
    
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
}
