//
//  UserDeafaults.swift
//  Alliegiant
//
//  Created by P10 on 31/07/24.
//

import Foundation
extension UserDefaults {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }

    var hasCompletedOnboarding: Bool {
        get {
            return bool(forKey: Keys.hasCompletedOnboarding)
        }
        set {
            set(newValue, forKey: Keys.hasCompletedOnboarding)
        }
    }
}
