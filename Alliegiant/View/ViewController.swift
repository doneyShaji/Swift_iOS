import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate{
    
    @IBOutlet weak var table: UITableView!
    
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

            // Table view Header -xib
            table.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")

            // Enable automatic dimension for row height - DYNAMIC CELL HEIGHT BASED ON THE CONTENT
            table.rowHeight = UITableView.automaticDimension

            if let tabBarController = self.tabBarController {
                tabBarController.delegate = self
            }
            table.separatorColor = .systemPink
            table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }

        
    @IBAction func cartAppleBtn(_ sender: Any) {
        print("here")
        guard let cartDetailVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                    fatalError("Unable to instantiate CartViewController from storyboard.")
                }
                navigationController?.pushViewController(cartDetailVC, animated: true)
    }
    
        
    
    @IBAction func menuButtonTapped(_ sender: Any) {

        let menuViewController = MenuViewController()
               menuViewController.modalPresentationStyle = .pageSheet
                if let sheet = menuViewController.sheetPresentationController {
                // Custom detent
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return 225 // The height you want for the view controller
                }
                sheet.detents = [customDetent]
                sheet.prefersGrabberVisible = true
            }
            present(menuViewController, animated: true)
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

//MARK: -TableView - Header
extension ViewController{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = table.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        // Configure with tinted effect
    
        if let userData = UserDefaults.standard.data(forKey: "userDetails"),
           let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String] {
            
            headerView.firstNameLabelXib.text = "\(userDetails["firstName"]!) \(userDetails["lastName"]!)"
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70 // Adjust the height as needed
    }
}

