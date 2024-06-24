//
//  DepartmentStoreViewController.swift
//  Alliegiant
//
//  Created by P10 on 24/06/24.
//

import UIKit

class DepartmentStoreViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    private let networkngManagerCocoaPods = NetworkingManagerCocoaPods()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func detailsButtonClick(_ sender: Any) {
        
        guard let urlToExecute = URL( string : "https://fakestoreapi.com/products") else{
            return
        }
        
        networkngManagerCocoaPods.execute(urlToExecute) { (json, error) in 
            if let error = error {
                self.textView.text = error.localizedDescription
            } else if let json = json {
                self.textView.text = json.description
            }
            
        }
    }
}
