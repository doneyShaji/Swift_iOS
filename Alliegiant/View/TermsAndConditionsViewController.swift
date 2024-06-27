//
//  TermsAndConditionsViewController.swift
//  Alliegiant
//
//  Created by P10 on 26/06/24.
//
import UIKit

class TermsAndConditionsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Terms and Conditions"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabel = UILabel()
        contentLabel.text = "By using Alliegiant, you agree to comply with our terms and conditions. We reserve the right to update or modify these terms at any time without prior notice. All products are subject to availability and may be withdrawn at any time. Prices are subject to change without notice. We are not responsible for any typographical errors or inaccuracies in product descriptions. You agree to provide accurate and current information when making a purchase and to comply with all applicable laws regarding online conduct and acceptable content. Unauthorized use of our website or its contents is prohibited. For more detailed terms, please visit our full Terms and Conditions page."
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

