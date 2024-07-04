//
//  HomeNavigationBar.swift
//  Alliegiant
//
//  Created by P10 on 03/07/24.
//

import UIKit

class HomeNavigationBar: UIView {

    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var helloHomeLabel: UILabel!
    @IBOutlet weak var nameHomeLabel: UILabel!
    @IBOutlet weak var catchPhraseLabel: UILabel!
//    
//    override init(frame: CGRect) {
//            super.init(frame: frame)
//            commonInit()
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            commonInit()
//        }
//
//    private func commonInit() {
//           guard let nibView = Bundle.main.loadNibNamed("WelcomeDesignHomePage", owner: self, options: nil)?.first as? UIView else {
//               return
//           }
//           contentView = nibView
//           addSubview(contentView)
//           contentView.frame = self.bounds
//           contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//       }
}
