//
//  OrderDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/08/24.
//

import UIKit
import CoreData

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var order: Order?
    var orderItems: [OrderItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOrderItems()
    }
    
    func fetchOrderItems() {
        guard let order = order else { return }
                orderItems = order.orderItems?.allObjects as? [OrderItem]
        orderTableView.reloadData()
    }
}


extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as? OrderDetailTableViewCell else {
                return UITableViewCell()
            }
            
            let item = orderItems?[indexPath.row]
            cell.orderDetailLbl.text = item?.productName
            cell.orderQuantityLbl.text = "Quantity: \(item?.quantity ?? 0)"
            cell.orderPriceLabel.text = "Price: \(item?.price ?? 0.0)"
            
        if let imageUrl = item?.imageURL {
                ImageLoader.loadImage(from: imageUrl) { image in
                    cell.orderImage.image = image
                }
            } else {
                cell.orderImage.image = nil
            }
            
            return cell
        }
}
