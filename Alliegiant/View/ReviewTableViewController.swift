//
//  ReviewTableViewController.swift
//  Alliegiant
//
//  Created by P10 on 29/07/24.
//

import UIKit

class ReviewTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var productId: Int?
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIMenu()
        setupTableView()
        fetchReviews()
        
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register a basic UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReviewCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchReviews() {
        guard let productId = productId else { return }
        
        WeatherManager().fetchReviews(for: productId) { [weak self] reviews in
            DispatchQueue.main.async {
                self?.reviews = reviews
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath)
        let review = reviews[indexPath.row]
        cell.textLabel?.text = "\(review.reviewerName): \(review.comment) - \(review.rating)⭐"
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setupUIMenu() {
        view.backgroundColor = .systemBackground
    }
}
