//
//  RegistrationTests.swift
//  AlliegiantTests
//
//  Created by P10 on 10/07/24.
//

import XCTest
@testable import Alliegiant

class RegistrationTests: XCTestCase {
    var signUpVC = SignUpViewController()
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            XCTFail("Could not instantiate SignUpViewController from main storyboard")
            return
        }
        signUpVC = viewController
        signUpVC.loadViewIfNeeded()
        
    }
    
    func testEmptyFirstName() {
        signUpVC.firstNameTextField.text = ""
        signUpVC.registerButtonTapped(self)
        XCTAssertEqual(signUpVC.firstNameErrorLabel.text, "First name is Invalid.")
    }
    
}
