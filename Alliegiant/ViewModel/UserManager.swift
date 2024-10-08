//
//  UserManager.swift
//  Alliegiant
//
//  Created by P10 on 12/06/24.
//

import Foundation
import CoreData
import UIKit
import FirebaseAuth

struct User {
    let userID: String
    let name: String
    let email: String
    let phoneNumber: String
    let gender: String
    let password: String
}

class UserManager {
    static let shared = UserManager()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var loggedInUser: User?

    var currentUser: User? {
        return loggedInUser
    }

    private init() {
        loadLoggedInUser()
    }

    func register(user: User, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            let userFirebaseID = Auth.auth().currentUser?.uid
            
            let newUser = RegisteredUsers(context: self.context)
            newUser.name = user.name
            newUser.emailAddress = user.email
            newUser.phoneNo = Int64(user.phoneNumber) ?? 0
            newUser.gender = user.gender
            newUser.userID = userFirebaseID
            
            do {
                try self.context.save()
                completion(true, nil)
            } catch {
                completion(false, "Failed to save user data: \(error.localizedDescription)")
            }
        }
    }

    func getRegisteredUsers() -> [User] {
        let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            return results.map { User(userID: $0.userID ?? "", name: $0.name ?? "", email: $0.emailAddress ?? "", phoneNumber: String($0.phoneNo), gender: $0.gender ?? "", password: "") }
        } catch {
            print("Failed to fetch registered users: \(error.localizedDescription)")
            return []
        }
    }

    func deleteUser(user: User) {
        let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userID == %@", user.userID)

        do {
            let results = try context.fetch(fetchRequest)
            if let userToDelete = results.first {
                context.delete(userToDelete)
                try context.save()
                print("User deleted successfully")
            } else {
                print("User not found")
            }
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "emailAddress == %@", email)

            do {
                let results = try self.context.fetch(fetchRequest)
                if let user = results.first {
                    self.loggedInUser = User(userID: user.userID ?? "", name: user.name ?? "", email: user.emailAddress ?? "", phoneNumber: String(user.phoneNo), gender: user.gender ?? "", password: "")
                    self.saveLoggedInUser()
                    completion(true, nil)
                } else {
                    completion(false, "User data not found in local storage.")
                }
            } catch {
                completion(false, "Failed to fetch user data: \(error.localizedDescription)")
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            loggedInUser = nil
            saveLoggedInUser()
        } catch {
            print("Failed to log out: \(error.localizedDescription)")
        }
    }

    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func updateUserDetails(_ updatedUser: User) {
        let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "emailAddress == %@", updatedUser.email)

        do {
            let results = try context.fetch(fetchRequest)
            if let userToUpdate = results.first {
                userToUpdate.name = updatedUser.name
                userToUpdate.emailAddress = updatedUser.email
                userToUpdate.phoneNo = Int64(updatedUser.phoneNumber) ?? 0
                try context.save()

                if loggedInUser?.email == updatedUser.email {
                    loggedInUser = updatedUser
                }
            }
        } catch {
            print("Failed to update user details: \(error.localizedDescription)")
        }
    }

    private func saveLoggedInUser() {
        if let user = loggedInUser {
            UserDefaults.standard.set(user.email, forKey: "loggedInUserEmail")
        } else {
            UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
        }
    }

    private func loadLoggedInUser() {
        if let email = UserDefaults.standard.string(forKey: "loggedInUserEmail") {
            let fetchRequest: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "emailAddress == %@", email)

            do {
                let results = try context.fetch(fetchRequest)
                if let user = results.first {
                    loggedInUser = User(userID: user.userID ?? "", name: user.name ?? "", email: user.emailAddress ?? "", phoneNumber: String(user.phoneNo), gender: user.gender ?? "", password: "")
                }
            } catch {
                print("Failed to load logged in user: \(error.localizedDescription)")
            }
        }
    }
}
