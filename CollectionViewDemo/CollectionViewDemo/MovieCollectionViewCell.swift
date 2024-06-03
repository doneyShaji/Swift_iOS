//
//  MyCollectionViewCell.swift
//  CollectionViewDemo
//
//  Created by P10 on 03/06/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieLabelTitle: UILabel!
    
    func setup(with movie: Movie){
        movieImageView.image = movie.image
        movieLabelTitle.text = movie.title
    }
}
