//
//  OrderDetailViewController.swift
//  Alliegiant
//
//  Created by P10 on 02/08/24.
//

import UIKit
import CoreData
import FirebaseAuth

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var order: Order?
    var orderItems: [OrderItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOrderItems()
        
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.doc"), style: .plain, target: self, action: #selector(pdfGenerator))
        cartButton.tintColor = .black
        navigationItem.rightBarButtonItem = cartButton
    }
    @objc func pdfGenerator() {
        
        let headerInfo: [String: String] = [
            "companyName": "Alliegiant Inc.",
            "userName": Auth.auth().currentUser?.displayName ?? "Guest",
            "userNumber": "Order #\(order?.orderID?.uuidString ?? "N/A")",
            "amount": "Total Amount: $\(String(format: "%.2f", order?.totalAmount ?? 0.0))"
        ]
        
        if let pdfData = orderTableView.exportInvoiceAsPDF(headerInfo: headerInfo) {
            saveAndShare(pdfData: pdfData)
        } else {
            print("Failed to create PDF.")
        }
    }

    func fetchOrderItems() {
        guard let order = order else { return }
                orderItems = order.orderItems?.allObjects as? [OrderItem]
        orderTableView.reloadData()
    }

    func saveAndShare(pdfData: Data) {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryFilePath = temporaryDirectory.appending("tableView.pdf")
        let temporaryFileURL = URL(fileURLWithPath: temporaryFilePath)
        
        do {
            try pdfData.write(to: temporaryFileURL)
            
            let activityViewController = UIActivityViewController(activityItems: [temporaryFileURL], applicationActivities: nil)
            
            // Find the topmost view controller
            if let topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                var currentController = topController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(activityViewController, animated: true, completion: nil)
            }
        } catch {
            print("Could not save PDF file: \(error)")
        }
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
