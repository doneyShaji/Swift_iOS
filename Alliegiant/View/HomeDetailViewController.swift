//
//  HomeDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 04/07/24.
//

import UIKit



class HomeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var targetScrollView: UIView!
    @IBOutlet var pageImage: UIPageControl!
    var seriesImage: [String] = ["card_1","card_2","card_3","card_4","card_5","card_6"]
    
    var addToCartDesign: AddToCart?
    var titleText: String?
    var images: [String] = []
    var descriptionDetail: String?
    var priceDetail: String?
    var ratingDetail: String?
    var availability: String?
    var maximumQuantity: String?
    var brandDetail: String?
    var warrantyDetail: String?
    var shippingDetail: String?
    var idDetail: Int?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionHome: UILabel!
    @IBOutlet weak var priceHome: UILabel!
    
    @IBOutlet weak var detaillView: UIView!
    
    @IBOutlet weak var readMore: UIButton!
    var isExpanded = false
    
    @IBOutlet weak var availabilityStatusHome: UILabel!
    @IBOutlet weak var maximumOrderQuantityHome: UILabel!
    @IBOutlet weak var brandHome: UILabel!
    @IBOutlet weak var warrantyInformationHome: UILabel!
    @IBOutlet weak var shippingInformationHome: UILabel!
    @IBOutlet weak var ratingDetailHome: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var reviewTableView: UITableView!
        var reviews: [Review] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detaillView.layer.cornerRadius = 50
        detaillView.translatesAutoresizingMaskIntoConstraints = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        titleLabel.text = titleText
        descriptionHome.text = descriptionDetail
        priceHome.text = priceDetail
        availabilityStatusHome.text = availability
        warrantyInformationHome.text = "Warranty: \(warrantyDetail ?? "")"
        shippingInformationHome.text = shippingDetail
        print(idDetail ?? 0)
        ratingDetailHome.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        // Underline the rating detail text with a star icon
        let starAttachment = NSTextAttachment()
        let starImage = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        starAttachment.image = starImage
        starAttachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12) // Adjust bounds as needed

        let starAttributedString = NSAttributedString(attachment: starAttachment)
        let textAttributedString = NSAttributedString(string: " \(ratingDetail ?? "") Reviews", attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 12) // Ensure the text font size matches the button's font size
        ])

        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(starAttributedString)
        combinedAttributedString.append(textAttributedString)

        ratingDetailHome.setAttributedTitle(combinedAttributedString, for: .normal)
        
        
        pageImage.currentPage = 0
        pageImage.numberOfPages = images.count
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        
        setupAddToCartDesign()
                setupReviewTableView()
                fetchReviews()


                
    }
    func setupAddToCartDesign() {
            let addToCartDesign = AddToCart(frame: .zero)
            view.addSubview(addToCartDesign)
            addToCartDesign.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addToCartDesign.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                addToCartDesign.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                addToCartDesign.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        func setupReviewTableView() {
            reviewTableView.dataSource = self
            reviewTableView.delegate = self
        }
        
    func fetchReviews() {
        guard let productId = idDetail else { return }
        WeatherManager().fetchReviews(for: productId) { [weak self] reviews in
            DispatchQueue.main.async {
                self?.reviews = reviews
                self?.reviewTableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        // Hide the tab bar
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        // Show the tab bar
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func readMoreBtnAction(_ sender: Any) {
        isExpanded.toggle()
                
        UIView.animate(withDuration: 0.3) {
            if self.isExpanded {
                self.descriptionHome.text = self.descriptionDetail
                self.descriptionHome.numberOfLines = 0
                self.readMore.setTitle("See Less", for: .normal)
                self.readMore.titleLabel?.font = UIFont.systemFont(ofSize: 9) // Set the font size to 9
            } else {
                self.descriptionHome.text = self.descriptionDetail
                self.descriptionHome.numberOfLines = 2
                self.readMore.setTitle("Read More", for: .normal)
                self.readMore.titleLabel?.font = UIFont.systemFont(ofSize: 9) // Set the font size to 9
            }
            
            self.view.layoutIfNeeded()
        

                }
    }
    
    @IBAction func reviewDisplayBtn(_ sender: Any) {
//        let reviewViewController = ReviewTableViewController()
//            reviewViewController.productId = idDetail // Pass the selected product ID here
//            reviewViewController.modalPresentationStyle = .pageSheet
//            if let sheet = reviewViewController.sheetPresentationController {
//                sheet.detents = [.medium()]
//                sheet.prefersGrabberVisible = true
//            }
//            present(reviewViewController, animated: true)
        // Calculate the target frame
               let targetRect = targetScrollView.frame
               scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    // MARK: - UITableViewDataSource methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return reviews.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
            let review = reviews[indexPath.row]
            cell.nameReview.text = review.reviewerName
            cell.ratingReview.text = String(review.rating)
            cell.descriptionReview.text = review.comment
            cell.emailReview.text = review.reviewerEmail
            
            return cell
        }
        
        // MARK: - UITableViewDelegate methods
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
}

extension HomeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        //        imageCell.imageView.image = UIImage(named: seriesImage[indexPath.row])
        let imageURL = images[indexPath.row]
        ImageLoader.loadImage(from: imageURL) { image in
            imageCell.imageView.image = image
        }
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageImage.currentPage = indexPath.row
        
    }
}

