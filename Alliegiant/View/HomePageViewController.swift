//
//  HomePageViewController.swift
//  Alliegiant
//
//  Created by Doney V. Shaji on 30/06/24.
//

import UIKit

class HomePageViewController: UIViewController {

    
    struct Details{
            let title: String
            let imageName: String
        }

        var homeData: [Details] = [
                Details(title: "MacBook Air M2", imageName: "Image1"),
                Details(title: "MacBook Air M2", imageName: "Image1"),
                Details(title: "MacBook Air M2", imageName: "Image1")
        ]
    
    var homeData1: [Details] = [
            Details(title: "MacBook Air M2", imageName: "image2"),
            Details(title: "MacBook Air M2", imageName: "image2"),
            Details(title: "MacBook Air M2", imageName: "image2")
    ]
    
    
    @IBOutlet weak var pages: UIPageControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageArray = ["card_1","card_2","card_3","card_4","card_5","card_6"]
    var index = 0
    
    
    @IBOutlet weak var tableViewHome: UITableView!
    @IBOutlet weak var segmentedControlHome: UISegmentedControl!
    let first = ["1","2","3","1","2","3","1","2","3","1","2","3","1","2","3"]
    let second = ["3","4","5","3","4","5","3","4","5","3","4","5","3","4","5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollingImgSetup), userInfo: nil, repeats: true)
    }
    @IBAction func segmentedControlBtn(_ sender: Any) {
        tableViewHome.reloadData()
    }
    
    @objc func scrollingImgSetup(){
        if index < imageArray.count - 1 {
            index = index + 1
        } else {
            index = 0
        }
        
        pages.numberOfPages = imageArray.count
        pages.currentPage = index
        imageCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
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

extension HomePageViewController {
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        tableViewHome.reloadData()
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlHome.selectedSegmentIndex {
        case 0:
            return homeData.count
        case 1:
            return homeData1.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt tableViewIndexPath: IndexPath) -> UITableViewCell {
        let segmentControlCell = tableViewHome.dequeueReusableCell(withIdentifier: "firstHomeCell", for: tableViewIndexPath) as! HomePageTableViewCell
        let tableData: Details

        switch segmentedControlHome.selectedSegmentIndex {
        case 0:
            tableData = homeData[tableViewIndexPath.row]
        case 1:
            tableData = homeData1[tableViewIndexPath.row]
        default:
            fatalError("Unexpected segment index")
        }

        segmentControlCell.homeTableViewIMG.image = UIImage(named: tableData.imageName)
        segmentControlCell.homeTableViewTitle.text = tableData.title
        
        return segmentControlCell
    }
}
