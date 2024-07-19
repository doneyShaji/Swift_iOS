//
//  RegisteredUsers+CoreDataProperties.swift
//  
//
//  Created by P10 on 19/07/24.
//
//

import Foundation
import CoreData


extension RegisteredUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegisteredUsers> {
        return NSFetchRequest<RegisteredUsers>(entityName: "RegisteredUsers")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var emailAddress: String?
    @NSManaged public var phoneNo: Int64
    @NSManaged public var password: String?

}
