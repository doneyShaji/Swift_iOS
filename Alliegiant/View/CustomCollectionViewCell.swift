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

        func setup(with colour: Colours) {
            titleLabel.text = colour.title
            ImageLoader.loadImage(from: colour.thumbnail) { [weak self] image in
                self?.thumbnailImageView.image = image
            }
        }
    }

