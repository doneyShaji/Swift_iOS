//
//  AddToCart.swift
//  Alliegiant
//
//  Created by P10 on 18/07/24.
//

import UIKit

class AddToCart: UIView {

    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var addToCart: UIButton!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commnonInit()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commnonInit()
    }
    
    func commnonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("AddToCart", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
