////
////  CustomCollectionViewController.swift
////  Alliegiant
////
////  Created by P10 on 04/06/24.
////
//
//import UIKit
//
//struct Colours{
//    let title: String
//}
//let colour : [Colours] = [
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED"),
//    Colours(title: "RED")
//    
//]
//var weatherManager_data = WeatherManager()
//
//
//class CustomCollectionViewController: UICollectionViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
////DATA SOURCE
//extension CustomCollectionViewController{
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return colour.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        var cell = UICollectionViewCell()
//        
//        if let colourCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell{
//            colourCell.setup(with: colour[indexPath.row])
//            cell = colourCell
//        }
//        return cell
//    }
//}
//
//
//
import UIKit

struct Colours {
    let title: String
}

var weatherManager = WeatherManager()

class CustomCollectionViewController: UICollectionViewController {
    var colours: [Colours] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ADDING THE ACTIVITY LOADER AND SHOWING IT
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        
        //Fetch the data and show the loader
        showActivityIndicator()
        weatherManager.fetchData { titles in
                    self.updateCollectionView(with: titles)
                    self.hideActivityIndicator()
                }
    }
    
    func updateCollectionView(with titles: [String]) {
        DispatchQueue.main.async {
            self.colours = titles.map { Colours(title: $0) }
            self.collectionView.reloadData()
        }
    }
    
    //function to display the activity loader
    func showActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }
    
    //function to hide the activity loader
    func hideActivityIndicator(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}

// DATA SOURCE
extension CustomCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colours.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let colourCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell {
            colourCell.setup(with: colours[indexPath.row])
            cell = colourCell
        }
        return cell
    }
}

extension CustomCollectionViewController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColour = colours[indexPath.row]
        
        if let detailCollectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController{
            
            detailCollectionVC.collectionLabel = selectedColour.title
            navigationController?.pushViewController(detailCollectionVC, animated: true)
        }
    }
}
