//
//  RegisteredUsersViewController.swift
//  Alliegiant
//
//  Created by P10 on 08/07/24.
//
// RegisteredUsersViewController.swift
import UIKit
import CoreData
class RegisteredUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var registeredUsersItems: [RegisteredUsers]?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up the table view
            tableView.delegate = self
            tableView.dataSource = self
            
            fetchData()
        }

        func fetchData() {
            do {
                self.registeredUsersItems = try context.fetch(RegisteredUsers.fetchRequest())
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to fetch users:", error.localizedDescription)
            }
        }
        
        // MARK: - UITableViewDataSource Methods
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return registeredUsersItems?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
                return UITableViewCell()
            }
            
            let registeredUserDetails = self.registeredUsersItems![indexPath.row]
            let firstNameText = registeredUserDetails.firstName ?? ""
            let lastNameText = registeredUserDetails.lastName ?? ""
            cell.nameLabel.text = "\(firstNameText) \(lastNameText)"
            cell.emailLabel.text = registeredUserDetails.emailAddress

            cell.deleteAction = { [weak self] in
                self?.deleteUser(at: indexPath)
            }
            
            return cell
        }
        
        // MARK: - Deletion Logic
        
        func deleteUser(at indexPath: IndexPath) {
            guard let userToDelete = registeredUsersItems?[indexPath.row] else { return }
            
            // Perform deletion in Core Data
            context.delete(userToDelete)
            
            do {
                try context.save()
                registeredUsersItems?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete user:", error.localizedDescription)
            }
        }
    }

