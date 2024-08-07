//
//  Order+CoreDataProperties.swift
//  
//
//  Created by P10 on 07/08/24.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var date: Date?
    @NSManaged public var orderID: UUID?
    @NSManaged public var totalAmount: Double
    @NSManaged public var user: String?
    @NSManaged public var orderItems: NSSet?
    @NSManaged public var users: RegisteredUsers?

}

// MARK: Generated accessors for orderItems
extension Order {

    @objc(addOrderItemsObject:)
    @NSManaged public func addToOrderItems(_ value: OrderItem)

    @objc(removeOrderItemsObject:)
    @NSManaged public func removeFromOrderItems(_ value: OrderItem)

    @objc(addOrderItems:)
    @NSManaged public func addToOrderItems(_ values: NSSet)

    @objc(removeOrderItems:)
    @NSManaged public func removeFromOrderItems(_ values: NSSet)

}
