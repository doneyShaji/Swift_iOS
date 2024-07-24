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
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupCell()
        }
        
        private func setupCell() {
            // Set up the cell's appearance
            contentView.backgroundColor = .white
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
            
            // Add padding around the content view
            contentView.frame = contentView.frame.insetBy(dx: 8, dy: 4)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Ensure rounded corners are applied correctly
            contentView.layer.cornerRadius = 10
        }
    }
