//
//  RegisteredUsersViewController.swift
//  Alliegiant
//
//  Created by P10 on 08/07/24.
//
// RegisteredUsersViewController.swift
import UIKit

class RegisteredUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Load the users
        users = UserManager.shared.getRegisteredUsers()
    }
    
    /// MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.nameLabel.text = "\(user.firstName) \(user.lastName)"
        cell.emailLabel.text = user.email
        cell.deleteAction = { [weak self] in
            self?.deleteUser(at: indexPath)
        }
        return cell
    }
    
    func deleteUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        UserManager.shared.deleteUser(user: user)
        users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

