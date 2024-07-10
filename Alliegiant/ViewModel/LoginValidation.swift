//
//  LoginValidation.swift
//  Alliegiant
//
//  Created by P10 on 09/07/24.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    var isNameValid: Bool {
        let nameRegex = "^[A-Za-z]{2,50}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: self)
    }
    
    var isTenDigits: Bool {
        let digitsRegex = "^[0-9]{10}$"
        let digitsPredicate = NSPredicate(format: "SELF MATCHES %@", digitsRegex)
        return digitsPredicate.evaluate(with: self)
    }

}
