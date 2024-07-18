//
//  Dummy.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class Dummy: UIViewController {
    var addToCartDesign: AddToCart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToCartDesign = AddToCart(frame: CGRect(x: 0, y: 500, width: view.frame.width, height: 50))
        if let addToCartDesign = addToCartDesign {
            view.addSubview(addToCartDesign)
        }
    }
}
