//
//  ProfileMenuVCViewController.swift
//  Alliegiant
//
//  Created by P10 on 01/07/24.
//

import UIKit

class ProfileMenuVCViewController: UIViewController {
    let termsAndConditionButton = UIButton()
    let aboutUsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIMenu()
        // Do any additional setup after loading the view.
    }
    
    @objc func termsAndConditionTapped(){
        let termsVC = TermsAndConditionsViewController()
        termsVC.sheetPresentationController?.detents = [.medium()]
        termsVC.sheetPresentationController?.prefersGrabberVisible = true
        present(termsVC, animated: true)
    }
    
    @objc func aboutUsTapped(){
        let termsVC = AboutUsViewController()
        termsVC.sheetPresentationController?.detents = [.medium()]
        termsVC.sheetPresentationController?.prefersGrabberVisible = true
        present(termsVC, animated: true)
    }
    
    func setupUIMenu(){
        view.addSubview(termsAndConditionButton)
        view.addSubview(aboutUsButton)
        view.backgroundColor = .systemBackground
        
        termsAndConditionButton.translatesAutoresizingMaskIntoConstraints = false
        aboutUsButton.translatesAutoresizingMaskIntoConstraints = false
        
        termsAndConditionButton.configuration = .tinted()
        termsAndConditionButton.configuration?.title = "Terms & Condition"
        termsAndConditionButton.configuration?.image = UIImage(systemName: "iphone")
        termsAndConditionButton.configuration?.imagePadding = 8
        termsAndConditionButton.configuration?.baseForegroundColor = .systemPink
        termsAndConditionButton.configuration?.baseBackgroundColor = .systemPink
        termsAndConditionButton.addTarget(self, action: #selector(termsAndConditionTapped), for: .touchUpInside)
        
        aboutUsButton.configuration = .tinted()
        aboutUsButton.configuration?.title = "About Us"
        aboutUsButton.configuration?.image = UIImage(systemName: "info.circle")
        aboutUsButton.configuration?.imagePadding = 8
        aboutUsButton.configuration?.baseForegroundColor = .systemIndigo
        aboutUsButton.configuration?.baseBackgroundColor = .systemIndigo
        aboutUsButton.addTarget(self, action: #selector(aboutUsTapped), for: .touchUpInside)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            aboutUsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutUsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            aboutUsButton.heightAnchor.constraint(equalToConstant: 50),
            aboutUsButton.widthAnchor.constraint(equalToConstant: 280),
            
            termsAndConditionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsAndConditionButton.topAnchor.constraint(equalTo: aboutUsButton.bottomAnchor, constant: padding),
            termsAndConditionButton.heightAnchor.constraint(equalToConstant: 50),
            termsAndConditionButton.widthAnchor.constraint(equalToConstant: 280)
        ])
        
    }
}
