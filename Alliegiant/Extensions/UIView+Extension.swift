//
//  UIView+Extension.swift
//  Alliegiant
//
//  Created by P10 on 31/07/24.
//

import UIKit

extension UIView{
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
