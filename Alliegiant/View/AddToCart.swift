//
//  AddToCart.swift
//  Alliegiant
//
//  Created by P10 on 18/07/24.
//

import UIKit
protocol AddToCartDelegate: AnyObject {
    func incrementQuantity()
    func decrementQuantity()
    func addToCart()
}

class AddToCart: UIView {
    
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var quantityStack: UIStackView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    @IBAction func incrementButton(_ sender: Any) {
        delegate?.incrementQuantity()
    }
    @IBAction func decrementButton(_ sender: Any) {
        delegate?.decrementQuantity()
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        delegate?.addToCart()
    }
    
    weak var delegate: AddToCartDelegate?
    
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
