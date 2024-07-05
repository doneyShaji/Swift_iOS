import UIKit

struct Colours {
    let title: String
    let thumbnail: String
    let description: String
    let price: Double
    let brand: String
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

    @IBAction func cartBtnTapped(_ sender: Any) {
        guard let cartVC = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                    fatalError("Unable to instantiate CartViewController from storyboard.")
                }
                navigationController?.pushViewController(cartVC, animated: true)
    }
    func updateCollectionView(with titlesAndThumbnails: [(String, String, String, Double, String)]) {
        DispatchQueue.main.async {
            self.colours = titlesAndThumbnails.map { Colours(title: $0, thumbnail: $1, description: $2, price: $3, brand: $4) }
            self.filteredColours = self.colours
            self.collectionView.reloadData()
        }
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
            detailCollectionVC.collectionPrice = "$\(String(selectedColour.price))"
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
            
            if let filterButton = searchView.viewWithTag(2) as? UIButton {
                configureFilterButton(filterButton)
            }
            return searchView
        }
    func configureFilterButton(_ button: UIButton) {
            let ascendingAction = UIAction(title: "Ascending (A-Z)") { _ in
                self.filteredColours.sort { $0.title < $1.title }
                self.collectionView.reloadData()
            }
            let descendingAction = UIAction(title: "Descending (Z-A)") { _ in
                self.filteredColours.sort { $0.title > $1.title }
                self.collectionView.reloadData()
            }
            let priceHighToLowAction = UIAction(title: "Price: High to Low") { _ in
                self.filteredColours.sort { $0.price > $1.price }
                self.collectionView.reloadData()
            }
            let priceLowToHighAction = UIAction(title: "Price: Low to High") { _ in
                self.filteredColours.sort { $0.price < $1.price }
                self.collectionView.reloadData()
            }
            let clearFilterAction = UIAction(title: "Clear Filter") { _ in
                self.filteredColours = self.colours
                self.collectionView.reloadData()
            }

            let menu = UIMenu(title: "", children: [ascendingAction, descendingAction, priceHighToLowAction, priceLowToHighAction, clearFilterAction])
            
        // Configure the button
            var configuration = UIButton.Configuration.tinted()
            configuration.title = "Sort"
            configuration.image = UIImage(systemName: "arrow.up.arrow.down")
            configuration.baseForegroundColor = .systemPink
            configuration.baseBackgroundColor = .systemPink

            // Adjust the text size
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14) // Adjust the font size here
            ]

            // Adjust the image size
            configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14) // Adjust the image size here

            button.configuration = configuration
            button.showsMenuAsPrimaryAction = true
            button.menu = menu
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
