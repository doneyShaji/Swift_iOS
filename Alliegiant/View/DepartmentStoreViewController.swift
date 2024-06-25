//
//  DepartmentStoreViewController.swift
//  Alliegiant
//
//  Created by P10 on 24/06/24.
//

import UIKit

class DepartmentStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var departmentStoreTable: UITableView!
    
    private var products: [DepartmentModel] = []
    private let networkingManager = NetworkingManagerCocoaPods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departmentStoreTable.dataSource = self
        departmentStoreTable.delegate = self
        
        loadDepartmentAPI()
        // Do any additional setup after loading the view.
    }
    
}

// MARK: - UITableViewDataSource
extension DepartmentStoreViewController{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return products.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let departmentCell = tableView.dequeueReusableCell(withIdentifier: "DepartmentStoreTableViewCell", for: indexPath) as! DepartmentStoreTableViewCell
            
            let product = products[indexPath.row]
                    
            departmentCell.departmentStoreTitleLabel.text = product.title
            departmentCell.departmentStorePriceLabel.text = String(format: "$%.2f", product.price)
            // Load the image using ImageLoader
            ActivityIndicator.shared.showActivityIndicator(on: departmentCell)
            ImageLoader.loadImage(from: product.image) { [weak departmentCell] image in
                DispatchQueue.main.async {
                    departmentCell?.departmentStoreImage.image = image
                    ActivityIndicator.shared.hideActivityIndicator()
                }
            }
                    
            return departmentCell
        }
}

extension DepartmentStoreViewController{
    func loadDepartmentAPI(){
        ActivityIndicator.shared.showActivityIndicator(on: view)
            guard let urlToExecute = URL(string: "https://fakestoreapi.com/products") else {
                return
            }
            
        networkingManager.execute(urlToExecute) { [weak self] (jsonArray, error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            // Handle error, e.g., show alert
                            print("Error: \(error.localizedDescription)")
                            ActivityIndicator.shared.hideActivityIndicator()
                        }
                    } else if let jsonArray = jsonArray {
                        // Convert JSON array to DepartmentModel instances
                        let products = jsonArray.compactMap { DepartmentModel(from: $0) }
                        
                        DispatchQueue.main.async {
                            self?.products = products
                            self?.departmentStoreTable.reloadData()
                            
                        }
                    }
                }
        }
}



    
