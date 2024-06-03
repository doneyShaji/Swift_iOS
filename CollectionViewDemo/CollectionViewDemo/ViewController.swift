//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by P10 on 03/06/24.
//

import UIKit


struct Movie{
    let title: String
    let image: UIImage
}

let movies: [Movie] = [
    Movie(title: "Image 1", image: #imageLiteral(resourceName: "image3")),
    Movie(title: "Image 2", image: #imageLiteral(resourceName: "image5")),
    Movie(title: "Image 3", image: #imageLiteral(resourceName: "image1")),
    Movie(title: "Image 4", image: #imageLiteral(resourceName: "image1")),
    Movie(title: "Image 5", image: #imageLiteral(resourceName: "image5"))]
class ViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
}
//DATA SOURCE
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.setup(with: movies[indexPath.row])
        return cell
    }
}

//DATA FLOW LAYOUT - COLUMNS
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 200)
    }
}
