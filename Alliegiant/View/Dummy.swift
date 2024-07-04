//
//  Dummy.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class Dummy: UIViewController {
    @IBOutlet weak var welcomeDesign: WelcomeDesignHomePage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        welcomeDesign.nameLabel.text = "Yellow"
    }
}
