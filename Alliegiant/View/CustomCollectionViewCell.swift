//
//  CustomCollectionViewCell.swift
//  Alliegiant
//
//  Created by P10 on 04/06/24.
//
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
            super.awakeFromNib()
            setupCellAppearance()
        }

        func setup(with colour: Colours) {
            titleLabel.text = colour.title
            ImageLoader.loadImage(from: colour.thumbnail) { [weak self] image in
                self?.thumbnailImageView.image = image
            }
        }

    private func setupCellAppearance() {
        // Add rounded corners
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        // Add shadow
        layer.shadowColor = UIColor.systemPink.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.masksToBounds = false

    
               // Remove any internal background color
               contentView.backgroundColor = .clear
    }
    }

