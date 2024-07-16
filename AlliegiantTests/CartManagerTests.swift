//
//  CartManagerTests.swift
//  AlliegiantTests
//
//  Created by P10 on 16/07/24.
//

import XCTest
@testable import Alliegiant // Replace with your actual module name

class CartManagerTests: XCTestCase {
    
    var cartManager: CartManager!
    
    override func setUp() {
        super.setUp()
        cartManager = CartManager.shared
        cartManager.clearCart()
    }
    
    override func tearDown() {
        cartManager.clearCart()
        cartManager = nil
        super.tearDown()
    }
    
    func testAddNewItem() {
        let item = CartItem(name: "Apple", image: "apple.jpg", price: "0.99", description: "Fresh apple", quantity: 2)
        cartManager.add(item: item)
        
        XCTAssertEqual(cartManager.items.count, 1)
        XCTAssertEqual(cartManager.items.first?.name, "Apple")
        XCTAssertEqual(cartManager.items.first?.quantity, 2)
        XCTAssertEqual(cartManager.items.first?.price, "0.99")
        XCTAssertEqual(cartManager.items.first?.description, "Fresh apple")
    }
    
    func testAddExistingItem() {
        let item1 = CartItem(name: "Banana", image: "banana.jpg", price: "0.59", description: "Yellow banana", quantity: 3)
        let item2 = CartItem(name: "Banana", image: "banana.jpg", price: "0.59", description: "Yellow banana", quantity: 2)
        
        cartManager.add(item: item1)
        cartManager.add(item: item2)
        
        XCTAssertEqual(cartManager.items.count, 1)
        XCTAssertEqual(cartManager.items.first?.name, "Banana")
        XCTAssertEqual(cartManager.items.first?.quantity, 2)
    }
    
    func testRemoveItem() {
        let item = CartItem(name: "Orange", image: "orange.jpg", price: "0.79", description: "Juicy orange", quantity: 5)
        cartManager.add(item: item)
        
        cartManager.remove(item: CartItem(name: "Orange", image: "orange.jpg", price: "0.79", description: "Juicy orange", quantity: 3))
        
        XCTAssertEqual(cartManager.items.count, 1)
        XCTAssertEqual(cartManager.items.first?.quantity, 2)
        
        cartManager.remove(item: CartItem(name: "Orange", image: "orange.jpg", price: "0.79", description: "Juicy orange", quantity: 2))
        
        XCTAssertEqual(cartManager.items.count, 0)
    }
    
    func testClearCart() {
        cartManager.add(item: CartItem(name: "Apple", image: "apple.jpg", price: "0.99", description: "Fresh apple", quantity: 2))
        cartManager.add(item: CartItem(name: "Banana", image: "banana.jpg", price: "0.59", description: "Yellow banana", quantity: 3))
        
        XCTAssertEqual(cartManager.items.count, 2)
        
        cartManager.clearCart()
        
        XCTAssertEqual(cartManager.items.count, 0)
    }
}
