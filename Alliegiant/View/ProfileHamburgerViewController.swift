//
//  ProfileHamburgerViewController.swift
//  Alliegiant
//
//  Created by P10 on 01/07/24.
//

import UIKit

class ProfileHamburgerViewController: UIViewController {

    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    var menuProfileOut = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHamburgerUI()
        // Do any additional setup after loading the view.
    }
    
    func setupHamburgerUI(){
        self.profileView.layer.cornerRadius = 30
        self.mainBackgroundView.clipsToBounds = true
    }
}
