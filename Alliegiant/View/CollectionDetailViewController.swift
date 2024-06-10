//
//  CollectionDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 06/06/24.
//

import UIKit

class CollectionDetailViewController: UIViewController {

    @IBOutlet weak var collectionDetailVC: UILabel!
    
    var collectionLabel: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionDetailVC.text = collectionLabel
        
    }
    

}
