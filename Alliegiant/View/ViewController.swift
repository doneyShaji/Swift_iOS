import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate{
    
    @IBOutlet weak var table: UITableView!
    var headerView: CustomHeaderView?
    struct Apple: Decodable {
        let title: String
        let imageName: String
        let productPrice: String
        let deliveryDescprition: String
        let productDescription: String
    }
    
    var data: [Apple] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        loadData()
        
        //Table view Header -xib
        
        table.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        // Enable automatic dimension for row height - DYNAMIC CELL HEIGHT BASED ON THE CONTENT
        // Removed the image's bottom constraint
        table.rowHeight = UITableView.automaticDimension
        
        // Set this ViewController as the delegate of the TabBarController
        if let tabBarController = self.tabBarController {
            tabBarController.delegate = self
        }
    }
    
    //Bundle Loading Code
    func loadData() {
            if let url = Bundle.main.url(forResource: "AppleProducts", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    self.data = try decoder.decode([Apple].self, from: data)
                    table.reloadData()
                } catch {
                    print("Error loading data: \(error)")
                }
            }
        }
    // MARK: - UITabBarControllerDelegate Methods
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            
            if let viewControllers = tabBarController.viewControllers {
                let index = viewControllers.firstIndex(of: viewController)!
                
                // Check if the tab bar item at the specific index is selected
                if index == 2 { // Replace 1 with the index of your specific tab bar item
                    // Perform your specific functionality here
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let myAccountVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as? MyAccountViewController {
                                myAccountVC.selectionDelegate = self
                                self.navigationController?.pushViewController(myAccountVC, animated: true)
                            }
                    return false // Return false if you don't want to switch to this tab
                }
            }
            return true
        }
        
        // Custom function to perform specific functionality
        func showAlert() {
            let alert = UIAlertController(title: "Tab Bar Item Clicked", message: "You clicked the second tab bar item!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     
}
    
// MARK: - Delegate Methods
extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "mySecondViewController") as! mySecondViewController
        let apple = data[indexPath.row]
        detailVC.myString = apple.title
        detailVC.myDisplayImage = UIImage(named: apple.imageName)
        detailVC.descriptionLabel = apple.productDescription
        detailVC.priceContent = apple.productPrice
        detailVC.deliveryContent = apple.deliveryDescprition
        detailVC.hidesBottomBarWhenPushed = true // Hide the tab bar
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Data Source Methods
extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let apple = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.label.text = apple.title
        cell.delivery.text = apple.deliveryDescprition
        cell.price.text = apple.productPrice
        cell.iconImageView.image = UIImage(named: apple.imageName)
        
        
        // for multiple lines
        cell.price.numberOfLines = 0

        return cell
    }
}

//TableView - Header
extension ViewController{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = table.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        if let userData = UserDefaults.standard.data(forKey: "userDetails"),
           let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String] {
            
            headerView.firstNameLabelXib.text = "\(userDetails["firstName"]!) \(userDetails["lastName"]!)"
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Adjust the height as needed
    }
}

// Delegate - Protocol - function
extension ViewController: UserDetailsDelegate{
    func didUpdateDetails(name: String) {
            print(name)
            
            // Update user details in UserDefaults or wherever you store them
            if var userDetails = UserDefaults.standard.dictionary(forKey: "userDetails") as? [String: String] {
                userDetails["firstName"] = name
                UserDefaults.standard.set(userDetails, forKey: "userDetails")
            }
            
            // Reload the section containing the header view
            table.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
}
