import UIKit

struct Colours {
    let title: String
    let thumbnail: String
    var description: String
}

var weatherManager = WeatherManager()

class CustomCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    var colours: [Colours] = []
    var filteredColours: [Colours] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var isSearching = false
    var searchBar: UISearchBar?
    var searchTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityIndicator.shared.showActivityIndicator(on: self.view)
        
        // Specify the category when calling fetchData
        weatherManager.fetchData(for: "mobile-accessories") { titlesAndThumbnails in
            self.updateCollectionView(with: titlesAndThumbnails)
            ActivityIndicator.shared.hideActivityIndicator()
        }
    }

    func updateCollectionView(with titlesAndThumbnails: [(String, String, String)]) {
        DispatchQueue.main.async {
            self.colours = titlesAndThumbnails.map { Colours(title: $0, thumbnail: $1, description: $2) }
            self.filteredColours = self.colours
            self.collectionView.reloadData()
        }
    }

    // Implement the UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 40 // total padding (left + right)
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2 - 10, height: collectionViewSize / 2)
    }
}

// MARK: - DATA SOURCE
extension CustomCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredColours.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.setup(with: filteredColours[indexPath.row])
        return cell
    }
}

// MARK: - DELEGATE
extension CustomCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColour = filteredColours[indexPath.row] // Use filteredColours instead of colours

        if let detailCollectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController {
            detailCollectionVC.hidesBottomBarWhenPushed = true // Hide the tab bar
            detailCollectionVC.collectionLabel = selectedColour.title
            detailCollectionVC.collectionImage = selectedColour.thumbnail
            detailCollectionVC.collectionDescription = selectedColour.description
            navigationController?.pushViewController(detailCollectionVC, animated: true)
        }
    }
}

// MARK: - Search Bar
extension CustomCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBarCollectionView", for: indexPath)
        if let searchBar = searchView.viewWithTag(1) as? UISearchBar {
            searchBar.delegate = self
            self.searchBar = searchBar
        }
        return searchView
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate() // Invalidate the previous timer
        searchTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(performSearch), userInfo: searchText, repeats: false)
    }

    @objc func performSearch(_ timer: Timer) {
        guard let searchText = timer.userInfo as? String else { return }
        if searchText.isEmpty {
            isSearching = false
            filteredColours = colours
        } else {
            isSearching = true
            filteredColours = colours.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
}
