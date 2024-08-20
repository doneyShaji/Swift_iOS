//
//  DiscountManager.swift
//  Alliegiant
//
//  Created by P10 on 20/08/24.
//

import Foundation

enum DiscountError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
class DiscountManager {
    func getDiscount(promoCode: String) async throws -> PromoCode {
        let endpoint = "http://localhost:8080/apply-discount"
        
        guard let url = URL(string: endpoint) else {
            throw DiscountError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["promoCode": promoCode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw DiscountError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PromoCode.self, from: data)
        } catch {
            throw DiscountError.invalidData
        }
    }
}
