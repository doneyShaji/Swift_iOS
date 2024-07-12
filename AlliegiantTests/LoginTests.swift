//
//  LoginTests.swift
//  AlliegiantTests
//
//  Created by P10 on 09/07/24.
//

import XCTest
@testable import Alliegiant

class LoginTests: XCTestCase {

    func testValidEmail() {
        XCTAssertTrue("test@example.com".isValidEmail)
        XCTAssertFalse("invalid-email".isValidEmail)
        XCTAssertFalse("invalid@domain".isValidEmail)
        XCTAssertTrue("user.name+tag+sorting@example.com".isValidEmail)
    }

    func testValidPassword() {
        XCTAssertTrue("password1".isValidPassword)
        XCTAssertFalse("password".isValidPassword)
        XCTAssertFalse("12345678".isValidPassword)
        XCTAssertFalse("short1".isValidPassword)
    }

    func testValidName() {
        XCTAssertTrue("John".isNameValid)
        XCTAssertFalse("D".isNameValid)
        XCTAssertFalse("Dawn123".isNameValid)
        XCTAssertFalse("Dawn Doney".isNameValid)
    }

    func testTenDigits() {
        XCTAssertTrue("1234567890".isTenDigits)
        XCTAssertFalse("123456789".isTenDigits)
        XCTAssertFalse("12345678901".isTenDigits)
        XCTAssertFalse("12345abcde".isTenDigits)
    }
}
