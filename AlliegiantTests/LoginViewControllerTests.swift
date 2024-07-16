//
//  LoginViewControllerTests.swift
//  AlliegiantTests
//
//  Created by P10 on 16/07/24.
//

import XCTest
@testable import Alliegiant

class LoginViewControllerTests: XCTestCase {
    var sut: LoginViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNotNil(sut.emailTextField)
        XCTAssertNotNil(sut.passwordTextField)
        XCTAssertNotNil(sut.loginButton)
        XCTAssertNotNil(sut.registerUsersButton)
    }
    
    func testUserManagerInteraction() {
        // Given
        sut.emailTextField.text = "test@example.com"
        sut.passwordTextField.text = "password123"
        
        // When
        sut.loginButtonTapped(UIButton())
        
        // Then
        XCTAssertTrue(UserManager.shared.isLoggedIn())
    }
    
    func testSignUpButtonTapped() {
        // Given
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        // When
        sut.signUpButtonTapped(UIButton())
        
        // Then
        XCTAssertTrue(mockNavigationController.pushedViewController is SignUpViewController)
    }

    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
