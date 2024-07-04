//
//  WelcomeDesignHomePage.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit

class WelcomeDesignHomePage: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commnonInit()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commnonInit()
    }
    
    func commnonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("WelcomeDesignHomePage", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }

}
