//
//  CartManager.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//

import Foundation
import UIKit
protocol CartManaging {
    var items: [CartItem] { get }
    func add(item: CartItem)
    func remove(item: CartItem)
    func clearCart()
}

class CartManager {
    static let shared = CartManager()
    private(set) var items: [CartItem] = []
    
    
    func clearCart() {
            items.removeAll()
        }
    
    init() {}
    
    func add(item: CartItem) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            items[index].quantity = item.quantity
        } else {
            items.append(item)
        }
    }
    
    func remove(item: CartItem) {
        if let index = items.firstIndex(where: { $0.name == item.name }) {
            items[index].quantity -= item.quantity
            if items[index].quantity <= 0 {
                items.remove(at: index)
            }
        }
    }
    
    func createOrder(for userID: String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newOrder = Order(context: context)
        newOrder.user = userID
        newOrder.date = Date()
        newOrder.orderID = UUID()
        newOrder.totalAmount = CartManager.shared.items.reduce(0) { $0 + ((Double($1.price) ?? 0) * Double($1.quantity))}
        
        for cartItem in CartManager.shared.items {
            let orderItem = OrderItem(context: context)
            orderItem.productName = cartItem.name
            orderItem.price = Double(cartItem.price) ?? 0
            orderItem.quantity = Int64(cartItem.quantity)
            orderItem.imageURL = cartItem.image
            orderItem.order = newOrder
            
            newOrder.addToOrderItems(orderItem)
            
        }
        
        do {
                try context.save()
                print("Order saved successfully")
            } catch {
                print("Failed to save order: \(error)")
            }
    }
}
extension CartManager: CartManaging {}


