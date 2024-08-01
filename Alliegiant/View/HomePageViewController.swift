//
//  HomePageViewController.swift
//  Alliegiant
//
//  Created by Doney V. Shaji on 30/06/24.
//

import UIKit
import CoreData
import FirebaseAuth

class HomePageViewController: UIViewController {
    
    struct Details {
        let id: Int
            let title: String
            let thumbnail: String
            let description: String
            let price: Double
            let brand: String
            let images: [String]
            let rating: Double
            let warrantyInformation: String
            let shippingInformation: String
            let availabilityStatus: String
            let minimumOrderQuantity: Int
            let returnPolicy: String
            let reviews: [Review]
        }
    
    
    var homeData: [Details] = []
    
    @IBOutlet weak var pages: UIPageControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var checkOutBtn: UIButton!
    var imageArray = ["card_1","card_2","card_3","card_4","card_5","card_6"]
    var index = 0
    
    @IBAction func checkOutBtnTapped(_ sender: Any) {
        print("here")
    }
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var segmentedControlHome: UISegmentedControl!
  
    // Declare customNavBar as an optional property
        var customNavBar: WelcomeDesignHomePage?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request: NSFetchRequest<RegisteredUsers> = RegisteredUsers.fetchRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Initialize and add the custom navigation bar
        customNavBar = WelcomeDesignHomePage(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
        
        if let user = Auth.auth().currentUser {
            print("User ID: \(user.displayName ?? "N")")
            customNavBar?.firstNameLabel.text = user.displayName ?? "N/A"
        }
        
        if let customNavBar = customNavBar {
            view.addSubview(customNavBar)
        }
        
        setupMyAccountViewController()
        
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        tableViewHome.separatorStyle = .none
        tableViewHome.rowHeight = 150
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollingImgSetup), userInfo: nil, repeats: true)
        loadSegmentData()
        
        setupSegmentedControl()
    }


        override func viewWillAppear(_ animated: Bool) {
            do {
                if let user = Auth.auth().currentUser {
                    print("User ID: \(user.displayName ?? "N")")
                    customNavBar?.firstNameLabel.text = user.displayName ?? "N/A"
                }
                } catch {
                    print("Failed to fetch user details:", error.localizedDescription)
                }
        }

    func updateTableView(with products: [Product]) {
            DispatchQueue.main.async {
                self.homeData = products.map { Details(id: $0.id, title: $0.title, thumbnail: $0.thumbnail, description: $0.description, price: $0.price, brand: $0.brand, images: $0.images, rating: $0.rating, warrantyInformation: $0.warrantyInformation, shippingInformation: $0.shippingInformation, availabilityStatus: $0.availabilityStatus, minimumOrderQuantity: $0.minimumOrderQuantity, returnPolicy: $0.returnPolicy, reviews: $0.reviews) }
                self.tableViewHome.reloadData()
                ActivityIndicator.shared.hideActivityIndicator()
                self.view.backgroundColor = .white
            }
        }
    
    @IBAction func menuHomeTapped(_ sender: Any) {
        print("here")
        let menuViewController = MyAccountViewController()
        menuViewController.modalPresentationStyle = .fullScreen
        present(menuViewController, animated: true)
                
    }
    @IBAction func segmentedControlBtn(_ sender: Any) {
        loadSegmentData()
    }
    
    @objc func scrollingImgSetup() {
            if index < imageArray.count - 1 {
                index += 1
            } else {
                index = 0
            }
            pages.numberOfPages = imageArray.count
            pages.currentPage = index
            imageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        }

    internal func loadSegmentData() {
            let category: String
            switch segmentedControlHome.selectedSegmentIndex {
            case 0:
                category = "womens-bags"
            case 1:
                category = "mens-shirts"
            default:
                return
            }
            ActivityIndicator.shared.showActivityIndicator(on: self.view)
            weatherManager.fetchData(for: category) { titlesAndThumbnails in
                self.updateTableView(with: titlesAndThumbnails)
            }
        }
    func setupMyAccountViewController() {
            if let myAccountVC = self.tabBarController?.viewControllers?[1] as? MyAccountViewController {
                myAccountVC.onNameUpdate = { [weak self] updatedName in
                    self?.customNavBar?.firstNameLabel.text = updatedName
                }
            }
        }
    private func setupSegmentedControl() {
            // Set the default text attributes for the unselected segments
            let unselectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white
            ]
            segmentedControlHome.setTitleTextAttributes(unselectedTextAttributes, for: .normal)

            // Set the text attributes for the selected segments
            let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black
            ]
            segmentedControlHome.setTitleTextAttributes(selectedTextAttributes, for: .selected)

            // Add target to handle value changes
            segmentedControlHome.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        }

        @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            for i in 0..<sender.numberOfSegments {
                let titleTextAttributes = i == sender.selectedSegmentIndex
                    ? [NSAttributedString.Key.foregroundColor: UIColor.black]
                    : [NSAttributedString.Key.foregroundColor: UIColor.white]
                sender.setTitleTextAttributes(titleTextAttributes, for: .normal)
                setupSegmentedControl()
            }
        }
    }
extension HomePageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt collectionViewIndexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageScrollView", for: collectionViewIndexPath) as? ImageScrollView
        imageCell?.scrollImage.image = UIImage(named: imageArray[collectionViewIndexPath.row])
        imageCell?.layer.borderWidth = 5
        imageCell?.layer.borderColor = UIColor.white.cgColor
        imageCell?.layer.cornerRadius = 20
        return imageCell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt collectionViewIndexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt tableViewIndexPath: IndexPath) -> UITableViewCell {
        let segmentControlCell = tableViewHome.dequeueReusableCell(withIdentifier: "firstHomeCell", for: tableViewIndexPath) as! HomePageTableViewCell
        let tableData = homeData[tableViewIndexPath.row]
        
        segmentControlCell.homeTableViewTitle.text = tableData.title
        segmentControlCell.homeBrandLabel.text = tableData.brand
        segmentControlCell.homePriceLabel.text = "$\(String(tableData.price))"
        segmentControlCell.descriptionHomeLabel.text = tableData.description
        ImageLoader.loadImage(from: tableData.thumbnail) { image in
            segmentControlCell.homeTableViewIMG.image = image
        }
        
        return segmentControlCell
    }
}


extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = homeData[indexPath.row]
        ImageLoader.loadImage(from: selectedProduct.thumbnail) { image in
            guard let homeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewController") as? HomeDetailViewController else {
                return
            }
            homeDetailVC.titleText = selectedProduct.title
            homeDetailVC.images = selectedProduct.images // Pass images array
            homeDetailVC.descriptionDetail = selectedProduct.description
            homeDetailVC.priceDetail = "$\(String(describing: selectedProduct.price))"
            homeDetailVC.ratingDetail = "\(String(describing: selectedProduct.rating))"
            homeDetailVC.availability = selectedProduct.availabilityStatus
            homeDetailVC.maximumQuantity = "\(String(describing: selectedProduct.minimumOrderQuantity))"
            homeDetailVC.brandDetail = selectedProduct.brand
            homeDetailVC.warrantyDetail = selectedProduct.warrantyInformation
            homeDetailVC.shippingDetail = selectedProduct.shippingInformation
            homeDetailVC.idDetail = selectedProduct.id
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(homeDetailVC, animated: true)
            }
        }
    }
}

