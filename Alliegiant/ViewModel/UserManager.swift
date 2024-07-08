import Foundation

// Define the User struct
struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let password: String
}

class UserManager {
    static let shared = UserManager()
    
    private let registeredUsersKey = "registeredUsers"
    private let loggedInUserKey = "loggedInUser"
    
    private var registeredUsers: [User] = []
    private var loggedInUser: User?
    
    var currentUser: User? {
        return loggedInUser
    }
    
    private init() {
        loadUsers()
        loadLoggedInUser()
    }
    
    func register(user: User) -> Bool {
        if registeredUsers.contains(where: { $0.email == user.email }) {
            return false // Email already exists
        }
        
        registeredUsers.append(user)
        saveUsers()
        return true
    }
    
    func getRegisteredUsers() -> [User] {
            return registeredUsers
        }
    func deleteUser(user: User) {
            if let index = registeredUsers.firstIndex(where: { $0.email == user.email }) {
                registeredUsers.remove(at: index)
                saveUsers()
            }
        }
    
    func login(email: String, password: String) -> Bool {
        if let user = registeredUsers.first(where: { $0.email == email && $0.password == password }) {
            loggedInUser = user
            saveLoggedInUser()
            return true
        }
        return false
    }
    
    func logout() {
        loggedInUser = nil
        saveLoggedInUser()
    }
    
    func isLoggedIn() -> Bool {
        return loggedInUser != nil
    }
    
    func updateUserDetails(_ updatedUser: User) {
        if let index = registeredUsers.firstIndex(where: { $0.email == updatedUser.email }) {
            registeredUsers[index] = updatedUser
            if loggedInUser?.email == updatedUser.email {
                loggedInUser = updatedUser
            }
            saveUsers()
            saveLoggedInUser()
        }
    }
    
    private func saveUsers() {
        if let data = try? JSONEncoder().encode(registeredUsers) {
            UserDefaults.standard.set(data, forKey: registeredUsersKey)
        }
    }
    
    private func loadUsers() {
        if let data = UserDefaults.standard.data(forKey: registeredUsersKey),
           let users = try? JSONDecoder().decode([User].self, from: data) {
            registeredUsers = users
        }
    }
    
    private func saveLoggedInUser() {
        if let user = loggedInUser {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: loggedInUserKey)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: loggedInUserKey)
        }
    }
    
    private func loadLoggedInUser() {
        if let data = UserDefaults.standard.data(forKey: loggedInUserKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            loggedInUser = user
        }
    }
}
