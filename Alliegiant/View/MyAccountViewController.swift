//
//  MyAccountViewController.swift
//  Alliegiant
//
//  Created by P10 on 17/06/24.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDetails()
    }
    func loadUserDetails() {
           if let userData = UserDefaults.standard.data(forKey: "userDetails"),
              let userDetails = try? JSONSerialization.jsonObject(with: userData, options: []) as? [String: String] {
               
               firstNameLabel.text = userDetails["firstName"]
               lastNameLabel.text = userDetails["lastName"]
               emailLabel.text = userDetails["email"]
           }
       }
}
