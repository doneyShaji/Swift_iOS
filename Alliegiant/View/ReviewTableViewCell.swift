//
//  ReviewTableViewCell.swift
//  Alliegiant
//
//  Created by P10 on 30/07/24.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameReview: UILabel!
    @IBOutlet weak var ratingReview: UILabel!
    @IBOutlet weak var emailReview: UILabel!
    @IBOutlet weak var descriptionReview: UILabel!
    
    let containerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 4
            return view
        }()
        
        override func awakeFromNib() {
            super.awakeFromNib()
            setupViews()
        }

        private func setupViews() {
            contentView.addSubview(containerView)
            containerView.addSubview(nameReview)
            containerView.addSubview(ratingReview)
            containerView.addSubview(descriptionReview)
            
            NSLayoutConstraint.activate([
                // Constraints for containerView
                            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                            
                            // Constraints for nameReview
                            nameReview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                            nameReview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                            nameReview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                            
                            // Constraints for ratingReview
                            ratingReview.topAnchor.constraint(equalTo: nameReview.bottomAnchor, constant: 10),
                            ratingReview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                            ratingReview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                            
                            
                            // Constraints for descriptionReview
                            descriptionReview.topAnchor.constraint(equalTo: ratingReview.bottomAnchor, constant: 10),
                            descriptionReview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                            descriptionReview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                            descriptionReview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            ])
        }
}
