//
//  MockCartManager.swift
//  AlliegiantTests
//
//  Created by P10 on 16/07/24.
//

import Foundation
@testable import Alliegiant
class MockCartManager: CartManaging {
    var items: [CartItem] = []
    var addedItem: CartItem?
    
    func add(item: CartItem) {
        addedItem = item
        items.append(item)
    }
    
    func remove(item: CartItem) {
        // Implement if needed for tests
    }
    
    func clearCart() {
        items.removeAll()
    }
}
