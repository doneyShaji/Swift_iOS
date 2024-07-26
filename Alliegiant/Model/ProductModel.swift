//
//  ProductModel.swift
//  Alliegiant
//
//  Created by P10 on 05/06/24.
//

import Foundation

struct ProductResponse: Decodable {
    let products: [Product]
}

struct Product: Decodable {
    let title: String
    let thumbnail: String
    let description: String
    let price: Double
    let brand: String
    let images: [String]
    let rating: Double
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let minimumOrderQuantity: Int
    let returnPolicy: String
    let reviews: [Review]
}

struct Review: Decodable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
}
