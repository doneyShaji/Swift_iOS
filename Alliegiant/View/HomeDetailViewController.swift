//
//  HomeDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class HomeDetailViewController: UIViewController {
    var titleText: String?
    var imageDetail: UIImage?
    var descriptionDetail: String?
    var priceDetail: String?
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHome: UIImageView!
    @IBOutlet weak var descriptionHome: UILabel!
    @IBOutlet weak var priceHome: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        titleLabel.text = titleText
        imageHome.image = imageDetail
        descriptionHome.text = descriptionDetail
        priceHome.text = priceDetail
            
        }
    // In HomeDetailViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    // In HomePageViewController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

}
