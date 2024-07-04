//
//  HomePageSecondDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class HomePageSecondDetailViewController: ViewController {

    @IBOutlet weak var imageHomeDetail: UIImageView!
    @IBOutlet weak var titleHomeDetail: UILabel!
    @IBOutlet weak var descriptionHomeDetail: UILabel!
    @IBOutlet weak var priceHomeDetail: UILabel!
        
    var titleHomeString: String?
        override func viewDidLoad() {
            super.viewDidLoad()
            
            titleHomeDetail.text = titleHomeString
        }
    
}
