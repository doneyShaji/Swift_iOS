//
//  mySecondViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/04/24.
//

import UIKit

class mySecondViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    //@IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var descriptionSeconVC: UILabel!
    @IBOutlet weak var priceDisplaySecondViewController: UILabel!
    @IBOutlet weak var deliveryDisplay: UILabel!
    
    
    //API
    
    var weatherManager = WeatherManager()
    
    
    var myString: String?
    var myDisplayImage: UIImage?
    var descriptionLabel: String?
    var priceContent: String?
    var deliveryContent: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = myString
        myImage.image = myDisplayImage
        descriptionSeconVC.text = descriptionLabel
        priceDisplaySecondViewController.text = priceContent
        deliveryDisplay.text = deliveryContent
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClickAPI(_ sender: Any) {
//        weatherManager.fetchData()
        weatherManager.fetchData { titlesAndThumbnails in
                   self.updateUI(with: titlesAndThumbnails)
               }
    }
    func updateUI(with titlesAndThumbnails: [(String, String, String)]) {
            DispatchQueue.main.async {
                // Here, you can update any UI components with the fetched data
                // For simplicity, we're just updating the `myLabel` with the first title
//                if let firstTitle = titles.first {
//                    self.myLabel.text = firstTitle
//                }
                // Update other UI components as needed
            }
        }
    
    
}
