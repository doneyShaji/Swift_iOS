//
//  OrdersViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/08/24.
//

import UIKit
import FirebaseAuth
import CoreData
class OrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items:[Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = []
        fetchOrders()
    }
    
    func fetchOrders() {
        let userID = Auth.auth().currentUser
        do
        {
            self.items = try context.fetch(Order.fetchRequest())
        
            tableView.reloadData()
        }
        catch {
            
        }
    }
}


extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
                let order = items?[indexPath.row]
                
                
                cell.textLabel?.text = "Order ID: \(order?.orderID?.uuidString ?? "")"
                cell.detailTextLabel?.text = "Total: \(order?.totalAmount ?? 0.0)"
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrder = items?[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let orderDetailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController {
                    orderDetailVC.order = selectedOrder
                    navigationController?.pushViewController(orderDetailVC, animated: true)
                }
    }
    
    
}
