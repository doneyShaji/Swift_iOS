import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
           // Clear saved user data
        print("here")
           UserDefaults.standard.removeObject(forKey: "userEmail")
           UserDefaults.standard.removeObject(forKey: "userPassword")
           
           // Navigate back to the login view controller
           if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
               loginViewController.modalPresentationStyle = .fullScreen
               present(loginViewController, animated: true, completion: nil)
           }
       }
    
    struct Apple {
        let title: String
        let imageName: String
        let productPrice: String
        let deliveryDescprition: String
        let productDescription: String
    }
    
    let data: [Apple] = [
        Apple(title: "MacBook Air M2", imageName: "Image1", productPrice: "₹ 99,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nModel Name: MacBook Air\nScreen Size: 13.6\nHard Disk Size: 256 GB\nRAM Memory: 8 GB"),
        Apple(title: "iPhone 15 Pro Max", imageName: "image2", productPrice: "₹ 1,48,800", deliveryDescprition: "FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr FREE delivery Sat, 20 Apr", productDescription: "Brand: Apple\nModel Name: iPhone 15 Pro Max\nOperating System: iOS\nCellular Technology: 5G"),
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
        
        // Enable automatic dimension for row height - DYNAMIC CELL HEIGHT BASED ON THE CONTENT
        // Removed the image's bottom constraint 
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
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
