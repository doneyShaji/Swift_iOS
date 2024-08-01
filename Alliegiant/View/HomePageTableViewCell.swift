//
//  HomePageTableViewCell.swift
//  Alliegiant
//
//  Created by Doney V. Shaji on 01/07/24.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var homeTableViewIMG: UIImageView!
    
    @IBOutlet weak var homeTableViewTitle: UILabel!
    
    @IBOutlet weak var homePriceLabel: UILabel!
    
    @IBOutlet weak var descriptionHomeLabel: UILabel!
    @IBOutlet weak var homeBrandLabel: UILabel!
    
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
            containerView.addSubview(homeTableViewIMG)
            containerView.addSubview(homeTableViewTitle)
            containerView.addSubview(homePriceLabel)
            containerView.addSubview(descriptionHomeLabel)
            containerView.addSubview(homeBrandLabel)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                
                homeTableViewIMG.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                homeTableViewIMG.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
                homeTableViewIMG.widthAnchor.constraint(equalToConstant: 130),
                homeTableViewIMG.heightAnchor.constraint(equalToConstant: 130),
                
                homeTableViewTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                homeTableViewTitle.leadingAnchor.constraint(equalTo: homeTableViewIMG.trailingAnchor, constant: 5),
                homeTableViewTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                
                homePriceLabel.topAnchor.constraint(equalTo: homeTableViewTitle.bottomAnchor, constant: 5),
                homePriceLabel.leadingAnchor.constraint(equalTo: homeTableViewIMG.trailingAnchor, constant: 5),
                homePriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                
                descriptionHomeLabel.topAnchor.constraint(equalTo: homePriceLabel.bottomAnchor, constant: 5),
                descriptionHomeLabel.leadingAnchor.constraint(equalTo: homeTableViewIMG.trailingAnchor, constant: 5),
                descriptionHomeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                
                homeBrandLabel.topAnchor.constraint(equalTo: descriptionHomeLabel.bottomAnchor, constant: 5),
                homeBrandLabel.leadingAnchor.constraint(equalTo: homeTableViewIMG.trailingAnchor, constant: 5),
                homeBrandLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                homeBrandLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            ])
        }
    }
