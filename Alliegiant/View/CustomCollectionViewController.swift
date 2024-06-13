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
    let thumbnail: String
    var description: String
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
        weatherManager.fetchData { titlesAndThumbnails in
                    self.updateCollectionView(with: titlesAndThumbnails)
                    self.hideActivityIndicator()
                }
    }
    
    func updateCollectionView(with titlesAndThumbnails: [(String, String, String)]) {
        DispatchQueue.main.async {
            self.colours = titlesAndThumbnails.map { Colours(title: $0, thumbnail: $1, description: $2) }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
            
            if indexPath.row == 0 {
                // Hardcoded description for the first item
                var firstDescription = colours[indexPath.row]
                firstDescription.description = "'A path from a point approximately 330 metres east of the most south westerly corner of 17 Batherton Close, Widnes and approximately 208 metres east-south-east of the most southerly corner of Unit 3 Foundry Industrial Estate, Victoria Street, Widnes, proceeding in a generally east-north-easterly direction for approximately 28 metres to a point approximately 202 metres east-south-east of the most south-easterly corner of Unit 4 Foundry Industrial Estate, Victoria Street, and approximately 347 metres east of the most south-easterly corner of 17 Batherton Close, then proceeding in a generally northerly direction for approximately 21 metres to a point approximately 210 metres east of the most south-easterly corner of Unit 5 Foundry Industrial Estate, Victoria Street, and approximately 202 metres east-south-east of the most north-easterly corner of Unit 4 Foundry Industrial Estate, Victoria Street, then proceeding in a generally east-north-east direction for approximately 64 metres to a point approximately 282 metres east-south-east of the most easterly corner of Unit 2 Foundry Industrial Estate, Victoria Street, Widnes and approximately 259 metres east of the most southerly corner of Unit 4 Foundry Industrial Estate, Victoria Street, then proceeding in a generally east-north-east direction for approximately 350 metres to a point approximately 3 metres west-north-west of the most north westerly corner of approximately 58 metres to a point approximately 216 metres east-south-east "
                cell.setup(with: firstDescription)
            } else {
                cell.setup(with: colours[indexPath.row])
            }

            return cell
        }
    
}
// DELEGATE
extension CustomCollectionViewController{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColour = colours[indexPath.row]
        
        if let detailCollectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController{
            
            detailCollectionVC.collectionLabel = selectedColour.title
            navigationController?.pushViewController(detailCollectionVC, animated: true)
        }
    }
}




