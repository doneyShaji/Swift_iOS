//
//  CollectionDetailViewControllerTests.swift
//  AlliegiantTests
//
//  Created by P10 on 16/07/24.
//

import XCTest
@testable import Alliegiant

class CollectionDetailViewControllerTests: XCTestCase {
    var sut: CollectionDetailViewController!
    var mockCartManager: MockCartManager!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController
        mockCartManager = MockCartManager()
                sut.cartManager = mockCartManager
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        mockCartManager = nil
        super.tearDown()
    }
    
    func testInitialSetup() {
        XCTAssertEqual(sut.title, "TechGear")
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertEqual(sut.quantity, 1)
        XCTAssertEqual(sut.quantityLabel.text, "1")
    }
    
    func testDataLoading() {
        sut.collectionLabel = "Test Product"
        sut.collectionDescription = "Test Description"
        sut.collectionPrice = "$99.99"
        sut.collectionImage = "https://example.com/image.jpg"
        
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.collectionDetailVC.text, "Test Product")
        XCTAssertEqual(sut.collectionViewDescription.text, "Test Description")
        XCTAssertEqual(sut.collectionViewPrice.text, "$99.99")
    }
    
    func testIncrementQuantity() {
        sut.incrementQuantity(UIButton())
        XCTAssertEqual(sut.quantity, 2)
        XCTAssertEqual(sut.quantityLabel.text, "2")
    }

    func testDecrementQuantity() {
        sut.quantity = 2
        sut.decrementQuantity(UIButton())
        XCTAssertEqual(sut.quantity, 1)
        XCTAssertEqual(sut.quantityLabel.text, "1")
    }

    func testDecrementQuantityMinimum() {
        sut.quantity = 1
        sut.decrementQuantity(UIButton())
        XCTAssertEqual(sut.quantity, 1)
        XCTAssertEqual(sut.quantityLabel.text, "1")
    }
    
    func testAddToCart() {
            sut.collectionLabel = "Test Product"
            sut.collectionImage = "https://example.com/image.jpg"
            sut.collectionPrice = "$99.99"
            sut.collectionDescription = "Test Description"
            sut.quantity = 2
            
            sut.addToCart(UIButton())
            
            XCTAssertEqual(mockCartManager.addedItem?.name, "Test Product")
            XCTAssertEqual(mockCartManager.addedItem?.quantity, 2)
            XCTAssertEqual(mockCartManager.addedItem?.image, "https://example.com/image.jpg")
            XCTAssertEqual(mockCartManager.addedItem?.price, "$99.99")
            XCTAssertEqual(mockCartManager.addedItem?.description, "Test Description")
        }
}
