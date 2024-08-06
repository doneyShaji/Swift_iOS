//
//  CartTableViewCell.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func didTapRemoveButton(on cell: CartTableViewCell)
}

class CartTableViewCell: UITableViewCell {
    weak var delegate: CartItemCellDelegate?
        
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        delegate?.didTapRemoveButton(on: self)
    }
    
    @IBOutlet weak var cartTitle: UILabel!
    @IBOutlet weak var cartQuantity: UILabel!
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartPrice: UILabel!

    }
