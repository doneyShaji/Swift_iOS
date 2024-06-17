
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
                firstDescription.description = "'A path from a point approximately 330 metres east of the most south westerly corner of 17 Batherton Close, Widnes and approximately 208 metres east-south-east of the most southerly corner of Unit 3 Foundry Industrial Estate, Victoria Street, Widnes, proceeding in a generally east-north-easterly direction for approximately "
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
            detailCollectionVC.hidesBottomBarWhenPushed = true // Hide the tab bar
            detailCollectionVC.collectionLabel = selectedColour.title
            detailCollectionVC.collectionImage = selectedColour.thumbnail
            detailCollectionVC.collectionDescription = selectedColour.description
            navigationController?.pushViewController(detailCollectionVC, animated: true)
        }
    }
}




