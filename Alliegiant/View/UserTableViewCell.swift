//
//  UserTableViewCell.swift
//  Alliegiant
//
//  Created by P10 on 08/07/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteAction: (() -> Void)?
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteAction?()
    }
}
