//
//  OrderItem+CoreDataProperties.swift
//  
//
//  Created by P10 on 07/08/24.
//
//

import Foundation
import CoreData


extension OrderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> {
        return NSFetchRequest<OrderItem>(entityName: "OrderItem")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var orderItemID: UUID?
    @NSManaged public var price: Double
    @NSManaged public var productName: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var order: Order?

}
