//
//  ViewController.swift
//  CollectionViewDynamic
//
//  Created by P10 on 13/06/24.
//

import UIKit

class ViewController: UIViewController {
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        collectionView?.register(MyCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.collectionViewLayout = layout
    }
    

}

