//
//  RegistrationTests.swift
//  AlliegiantTests
//
//  Created by P10 on 10/07/24.
//

import XCTest
@testable import Alliegiant

//class RegistrationTests: XCTestCase {
//    var signUpVC = SignUpViewController()
//    override func setUp() {
//        super.setUp()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
//            XCTFail("Could not instantiate SignUpViewController from main storyboard")
//            return
//        }
//        signUpVC = viewController
//        signUpVC.loadViewIfNeeded()
//        
//    }
//    
//    func testEmptyFirstName() {
//        signUpVC.firstNameTextField.text = ""
//        signUpVC.registerButtonTapped(self)
//        XCTAssertEqual(signUpVC.firstNameErrorLabel.text, "First name is Invalid.")
//    }
//    
//}
class RegistrationTests: XCTestCase {
    var signUpVC: SignUpViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        signUpVC.loadViewIfNeeded()
    }

    func testTextFieldDelegates() {
        XCTAssertEqual(signUpVC.firstNameTextField.delegate as? SignUpViewController, signUpVC)
        XCTAssertEqual(signUpVC.lastNameTextField.delegate as? SignUpViewController, signUpVC)
        XCTAssertEqual(signUpVC.emailAddressTextField.delegate as? SignUpViewController, signUpVC)
        XCTAssertEqual(signUpVC.phoneNumberTextField.delegate as? SignUpViewController, signUpVC)
        XCTAssertEqual(signUpVC.passwordTextField.delegate as? SignUpViewController, signUpVC)
        XCTAssertEqual(signUpVC.confirmPasswordTextField.delegate as? SignUpViewController, signUpVC)
    }

    func testErrorLabelsClearedOnBeginEditing() {
        signUpVC.firstNameErrorLabel.text = "Error"
        signUpVC.textFieldDidBeginEditing(signUpVC.firstNameTextField)
        XCTAssertEqual(signUpVC.firstNameErrorLabel.text, "")
    }

    func testRegistrationWithValidInput() {
        signUpVC.firstNameTextField.text = "John"
        signUpVC.lastNameTextField.text = "Doe"
        signUpVC.emailAddressTextField.text = "john.doe@example.com"
        signUpVC.phoneNumberTextField.text = "1234567890"
        signUpVC.passwordTextField.text = "Password123"
        signUpVC.confirmPasswordTextField.text = "Password123"

        signUpVC.registerButtonTapped(self)
        
        // Assuming UserManager.shared.register(user:) and login(email:password:) return true
        XCTAssertTrue(UserManager.shared.isLoggedIn())
    }
    
}

class UserManagerTests: XCTestCase {
    var userManager: UserManager!

    override func setUp() {
        super.setUp()
        userManager = UserManager.shared
        userManager.registeredUsers.removeAll()
        userManager.logout()
    }

    func testRegisterUser() {
        let user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        let result = userManager.register(user: user)
        XCTAssertTrue(result)
        XCTAssertEqual(userManager.getRegisteredUsers().count, 1)
    }

    func testRegisterUserWithExistingEmail() {
        let user1 = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        let user2 = User(firstName: "Jane", lastName: "Smith", email: "john.doe@example.com", phoneNumber: "0987654321", password: "Password456")
        userManager.register(user: user1)
        let result = userManager.register(user: user2)
        XCTAssertFalse(result)
        XCTAssertEqual(userManager.getRegisteredUsers().count, 1)
    }

    func testLoginUser() {
        let user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        userManager.register(user: user)
        let result = userManager.login(email: "john.doe@example.com", password: "Password123")
        XCTAssertTrue(result)
        XCTAssertEqual(userManager.currentUser?.email, "john.doe@example.com")
    }

    func testLoginWithInvalidCredentials() {
        let user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        userManager.register(user: user)
        let result = userManager.login(email: "john.doe@example.com", password: "WrongPassword")
        XCTAssertFalse(result)
    }

    func testLogout() {
        let user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        userManager.register(user: user)
        userManager.login(email: "john.doe@example.com", password: "Password123")
        userManager.logout()
        XCTAssertNil(userManager.currentUser)
    }
    
    func testDeleteUser() {
        let user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        userManager.register(user: user)
        XCTAssertEqual(userManager.getRegisteredUsers().count, 1)
        
        userManager.deleteUser(user: user)
        XCTAssertEqual(userManager.getRegisteredUsers().count, 0)
    }
    
    func testUpdateUserDetails() {
        var user = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "1234567890", password: "Password123")
        userManager.register(user: user)
        userManager.login(email: "john.doe@example.com", password: "Password123")
        
        let updatedUser = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: "0987654321", password: "NewPassword123")
        userManager.updateUserDetails(updatedUser)
        
        XCTAssertEqual(userManager.currentUser?.phoneNumber, "0987654321")
        XCTAssertEqual(userManager.currentUser?.password, "NewPassword123")
    }
    
    func testSingletonBehavior() {
        let instance1 = UserManager.shared
        let instance2 = UserManager.shared
        XCTAssertTrue(instance1 === instance2)
    }
}

