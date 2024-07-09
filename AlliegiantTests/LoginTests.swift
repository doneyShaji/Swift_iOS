//
//  LoginTests.swift
//  AlliegiantTests
//
//  Created by P10 on 09/07/24.
//

import XCTest
@testable import Alliegiant

final class LoginTests: XCTestCase {

    
    func testInvalidPassword(){
        //Given - Arrange
        let password = "1234"
        //When - Act
        let isValid = password.isValidPassword
        //Then - Assert
        XCTAssertFalse(isValid, "Password Incorrect")
        XCTAssertFalse("12345678".isValidPassword, "Password should be considered too short")
        XCTAssertFalse("alpha".isValidPassword, "Password should be considered too short")
    }
    
    }
//    
//    func testEmailAlpha(){
//        //Given - Arrange
//        let email = ""
//        //When - Act
//        let isValid = registrationVC.isValidEmail(email)
//        //Then - Assert
//        XCTAssertFalse(isValid, "Password should be considered empty")
//    }

