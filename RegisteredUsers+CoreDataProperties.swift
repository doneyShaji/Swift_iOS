//
//  RegisteredUsers+CoreDataProperties.swift
//  
//
//  Created by P10 on 07/08/24.
//
//

import Foundation
import CoreData


extension RegisteredUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegisteredUsers> {
        return NSFetchRequest<RegisteredUsers>(entityName: "RegisteredUsers")
    }

    @NSManaged public var country: String?
    @NSManaged public var emailAddress: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNo: Int64
    @NSManaged public var userID: String?
    @NSManaged public var orders: NSSet?

}

// MARK: Generated accessors for orders
extension RegisteredUsers {

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSSet)

}
