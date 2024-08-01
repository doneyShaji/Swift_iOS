//
//  OnboardingViewController.swift
//  Alliegiant
//
//  Created by P10 on 31/07/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionViewOnboard: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                
                nextBtn.setTitle("Getting Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            OnboardingSlide(title: "Effortless Ordering", description: "Browse and place orders with ease, from anywhere, at any time.", image: #imageLiteral(resourceName: "Shopping")),
                  OnboardingSlide(title: "Simple & Secure Payments", description: "Experience hassle-free payments with secure and flexible options.", image: #imageLiteral(resourceName: "Payment")),
                  OnboardingSlide(title: "Fast & Reliable Delivery", description: "Enjoy quick and reliable delivery to your doorstep, no matter your location.", image: #imageLiteral(resourceName: "Delivery"))
        ]
        
        collectionViewOnboard.dataSource = self
        collectionViewOnboard.delegate = self
    }
    @IBAction func nextBtnClicked(_ sender: Any) {
        if currentPage == slides.count - 1{
            UserDefaults.standard.hasCompletedOnboarding = true
            let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionViewOnboard.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let onboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        onboardCell.setup(slides[indexPath.row])
        return onboardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //Delegate to know when scroll has occurred
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
