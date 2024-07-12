//
//  RegistrationTests.swift
//  AlliegiantTests
//
//  Created by P10 on 10/07/24.
//

import XCTest
@testable import Alliegiant

final class RegistrationTests: XCTestCase {
    func testInvalidPassword(){
        //Given - Arrange
        let password = "1234"
        //When - Act
        let isValid = password.isValidPassword
        //Then - Assert
        XCTAssertFalse(isValid, "Password Invalid")
        XCTAssertFalse("12345678".isValidPassword, "Password Invalid")
        XCTAssertFalse("alpha".isValidPassword, "Password Invalid")
        XCTAssertFalse("alpha!dea".isValidPassword, "Password Invalid")
    }
    func testValidPassword(){
        XCTAssertTrue("12345678a".isValidPassword, "Password Valid")
        XCTAssertTrue("asdfghjk1".isValidPassword, "Password Valid")
        XCTAssertTrue("alpha12345".isValidPassword, "Password Valid")
    }

}
