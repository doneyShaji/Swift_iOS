//
//  CartManager.swift
//  Alliegiant
//
//  Created by P10 on 02/07/24.
//

import Foundation
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
}
extension CartManager: CartManaging {}


