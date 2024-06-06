//
//  ViewController.swift
//  Alliegiant
//
//  Created by P10 on 16/04/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    struct Apple{
        let title: String
        let imageName: String
        let productPrice: String
        let deliveryDescprition: String
        let productDescription: String
    }
    
    let data: [Apple] = [
        Apple(title: "MacBook Air M2", imageName: "Image1", productPrice: "₹ 99,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Model Name: MacBook Air \n Screen Size:  13.6\n Hard Disk Size: 256 GB\n RAM Memory: 8 GB"),
        Apple(title: "iPhone 15 Pro Max", imageName: "image2", productPrice: "₹ 1,48,800", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Model Name: iPhone 15 Pro Max \n Operating System: iOS\n Cellular Technology: 5G"),
        Apple(title: "Apple Watch SE", imageName: "image3", productPrice: "₹ 30,000", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Style: GPS\n Special Feature: Heart Rate Monitor\n Shape: Square"),
        Apple(title: "AirPods (3rd generation)", imageName: "image4", productPrice: "₹ 19,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Model Name: AirPods Pro (3rd Gen, 2024)\n Colour: White\n Form Factor: In Ear\n Connectivity Technology: Wireless"),
        Apple(title: "iMac", imageName: "image5", productPrice: "₹ 1,34,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Operating System: Mac OS\n Memory Storage Capacity: 256 GB\n Screen Size: 24 Inches\n RAM Memory: 8 GB\n CPU Model: Apple M2 Ultra"),
        Apple(title: "Apple TV", imageName: "image6", productPrice: "₹ 14,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " Brand: Apple\n Connectivity Technology: Bluetooth, Wi-Fi\n Connector Type: DMI\n Special Feature: High Definition\n Resolution: 4k\n Supported Services: Netflix, HBO Max"),
        Apple(title: "AirPods Max", imageName: "image7", productPrice: "₹ 59,900", deliveryDescprition: "FREE delivery Sat, 20 Apr", productDescription: " BRAND: Apple\n MODEL NAME: Airpods Max\n HEADPHONE TYPE: Over the head\n WIRED/WIRELESS: Wireless")
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }
    
    
}

//MARK - DELEGATE VIEW CONTROLLER
extension ViewController{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "mySecondViewController") as! mySecondViewController
        detailVC.myString = data[indexPath.row].title
        detailVC.myDisplayImage = UIImage(named: data[indexPath.row].imageName)
        detailVC.descriptionLabel = data[indexPath.row].productDescription
        detailVC.priceContent = data[indexPath.row].productPrice
        detailVC.deliveryContent = data[indexPath.row].deliveryDescprition
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK - DATA SOURCE
extension ViewController{
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
        return cell
    }
}



