//
//  AboutUsViewController.swift
//  Alliegiant
//
//  Created by P10 on 26/06/24.
//

import UIKit

class AboutUsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "About Us"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabel = UILabel()
        contentLabel.text = """
Welcome to Alliegiant!

At Alliegiant we believe shopping should be an enjoyable and seamless experience. Our mission is to provide you with the best products at unbeatable prices, all from the comfort of your home. We aim to continuously expand our product range and enhance our services to meet the evolving needs of our customers. Our vision is to be the go-to destination for online shopping, offering an unparalleled experience that combines convenience, variety, and affordability.

Thank you for choosing Alliegiant. Happy shopping!
"""
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

