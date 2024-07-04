//
//  HomePageViewController.swift
//  Alliegiant
//
//  Created by Doney V. Shaji on 30/06/24.
//

import UIKit

class HomePageViewController: UIViewController {
    
    struct Details {
            let title: String
            let thumbnail: String
            let description: String
            let price: Double
            let brand: String
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
    let first = ["1","2","3","1","2","3","1","2","3","1","2","3","1","2","3"]
    let second = ["3","4","5","3","4","5","3","4","5","3","4","5","3","4","5"]
  

        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.isNavigationBarHidden = true

            // Load and add the custom navigation bar
            let customNavBar = WelcomeDesignHomePage(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50))
            customNavBar.firstNameLabel.text = "Doney"
            view.addSubview(customNavBar)

            
            tableViewHome.delegate = self
                    tableViewHome.dataSource = self
                Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollingImgSetup), userInfo: nil, repeats: true)
                loadSegmentData()
        }

        func updateTableView(with titlesAndThumbnails: [(String, String, String, Double, String)]) {
            DispatchQueue.main.async {
                self.homeData = titlesAndThumbnails.map { Details(title: $0, thumbnail: $1, description: $2, price: $3, brand: $4) }
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

        private func loadSegmentData() {
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
            segmentControlCell.homeBrandLabel.text =  tableData.brand
            segmentControlCell.homePriceLabel.text = "$\(String(tableData.price))"
            ImageLoader.loadImage(from: tableData.thumbnail) { image in
                segmentControlCell.homeTableViewIMG.image = image
            }
            
            return segmentControlCell
        }
}

extension HomePageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = homeData[indexPath.row]
                ImageLoader.loadImage(from: selectedProduct.thumbnail) { image in
                    guard let homeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeDetailViewController") as? HomeDetailViewController else {
                        return
                    }
                    homeDetailVC.titleText = selectedProduct.title
                    homeDetailVC.imageDetail = image
                    homeDetailVC.descriptionDetail = selectedProduct.description
                    homeDetailVC.priceDetail = "$\(String(selectedProduct.price))"
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(homeDetailVC, animated: true)
                    }
                }
        }
}
