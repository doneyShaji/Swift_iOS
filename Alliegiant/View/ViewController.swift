import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserDetailsDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    struct Apple {
        let title: String
        let imageName: String
        let productPrice: String
        let deliveryDescprition: String
        let productDescription: String
    }
    
    let data: [Apple] = [
        Apple(title: "MacBook Air M2", imageName: "Image1", productPrice: "₹ 99,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nModel Name: MacBook Air\nScreen Size: 13.6\nHard Disk Size: 256 GB\nRAM Memory: 8 GB"),
        Apple(title: "iPhone 15 Pro Max", imageName: "image2", productPrice: "₹ 1,48,800", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nModel Name: iPhone 15 Pro Max\nOperating System: iOS\nCellular Technology: 5G"),
        Apple(title: "Apple Watch SE", imageName: "image3", productPrice: "₹ 30,000", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nStyle: GPS\nSpecial Feature: Heart Rate Monitor\nShape: Square"),
        Apple(title: "AirPods (3rd generation)", imageName: "image4", productPrice: "₹ 19,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nModel Name: AirPods Pro (3rd Gen, 2024)\nColour: White\nForm Factor: In Ear\nConnectivity Technology: Wireless"),
        Apple(title: "iMac", imageName: "image5", productPrice: "₹ 1,34,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nOperating System: Mac OS\nMemory Storage Capacity: 256 GB\nScreen Size: 24 Inches\nRAM Memory: 8 GB\nCPU Model: Apple M2 Ultra"),
        Apple(title: "Apple TV", imageName: "image6", productPrice: "₹ 14,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nConnectivity Technology: Bluetooth, Wi-Fi\nConnector Type: HDMI\nSpecial Feature: High Definition\nResolution: 4k\nSupported Services: Netflix, HBO Max"),
        Apple(title: "AirPods Max", imageName: "image7", productPrice: "₹ 59,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "BRAND: Apple\nMODEL NAME: Airpods Max\nHEADPHONE TYPE: Over the head\nWIRED/WIRELESS: Wireless")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
        // Set the delegate when navigating to MyAccountViewController
                if let accountVC = storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as? MyAccountViewController {
                    accountVC.selectionDelegate = self
                }
        //Table view Header -xib
        
        table.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        
        // Enable automatic dimension for row height - DYNAMIC CELL HEIGHT BASED ON THE CONTENT
        // Removed the image's bottom constraint
        table.rowHeight = UITableView.automaticDimension
    }
    
    func didUpdateUserDetails(name: String) {
        // Reload the table view header
//        table.reloadSections(IndexSet(integer: 0), with: .automatic)
        print(name)
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let myAccountVC = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as? MyAccountViewController {
                    self.navigationController?.pushViewController(myAccountVC, animated: true)
                }
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

extension ViewController{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = table.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        if let userData = UserDefaults.standard.data(forKey: "userDetails"),
           let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String] {
            
            headerView.firstNameLabelXib.text = userDetails["firstName"]}
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // Adjust the height as needed
    }
}

//extension ViewController: UserDetailsDelegate {
//    func didUpdateUserDetails(name: String) {
//        // Reload the table view header
////        table.reloadSections(IndexSet(integer: 0), with: .automatic)
//        print(name)
//    }
//}
