//
//  DepartmentStoreProductModel.swift
//  Alliegiant
//
//  Created by P10 on 25/06/24.
//

import Foundation

struct DepartmentModel{
    let title: String
    let price: Double
    let image: String
    init?(from json: [String: Any]) {
            guard let title = json["title"] as? String,
                  let price = json["price"] as? Double,
                  let image = json["image"] as? String else {
                return nil
            }
            
            self.title = title
            self.price = price
            self.image = image
        }
}

