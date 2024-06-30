import Foundation

// Define the User struct
struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
}

// Helper class to manage users
class UserManager {
    static let shared = UserManager()
    
    private let registeredUsersKey = "registeredUsers"
    private let loggedInUserKey = "loggedInUser"
    
    private var registeredUsers: [User] = []
    private var loggedInUser: User?
    
    private init() {
        loadUsers()
        loadLoggedInUser()
    }
    
    // Register a new user
    func register(user: User) -> Bool {
        if registeredUsers.contains(where: { $0.email == user.email }) {
            return false // Email already exists
        }
        
        registeredUsers.append(user)
        saveUsers()
        return true
    }
    
    // Login a user
    func login(email: String, password: String) -> Bool {
        if let user = registeredUsers.first(where: { $0.email == email && $0.password == password }) {
            loggedInUser = user
            saveLoggedInUser()
            return true
        }
        return false
    }
    
    // Logout the current user
    func logout() {
        loggedInUser = nil
        saveLoggedInUser()
    }
    
    // Check if a user is logged in
    func isLoggedIn() -> Bool {
        return loggedInUser != nil
    }
    
    // Save registered users to UserDefaults as JSON
    private func saveUsers() {
        if let data = try? JSONEncoder().encode(registeredUsers) {
            UserDefaults.standard.set(data, forKey: registeredUsersKey)
        }
    }
    
    // Load registered users from UserDefaults as JSON
    private func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: registeredUsersKey),
           let users = try? JSONDecoder().decode([User].self, from: data) {
            registeredUsers = users
        }
    }
    
    // Save logged-in user to UserDefaults as JSON
    private func saveLoggedInUser() {
        if let user = loggedInUser {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: loggedInUserKey)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: loggedInUserKey)
        }
    }
    
    // Load logged-in user from UserDefaults as JSON
    private func loadLoggedInUser() {
        if let data = UserDefaults.standard.data(forKey: loggedInUserKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            loggedInUser = user
        }
    }
}
