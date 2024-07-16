//
//  MockWeatherManager.swift
//  AlliegiantTests
//
//  Created by P10 on 15/07/24.
//

import Foundation
@testable import Alliegiant

class MockWeatherManager {
    var mockData: [(String, String, String, Double, String)] = []
        var fetchDataCalled = false
        var performRequestCalled = false
        var parseJSONCalled = false
        var lastFetchedCategory: String?
        var lastRequestedURL: String?
}

extension MockWeatherManager: WeatherManagerProtocol{
    func fetchData(for category: String, completion: @escaping ([(String, String, String, Double, String)]) -> Void) {
            fetchDataCalled = true
            lastFetchedCategory = category
            completion(mockData)
        }
        
        func performRequest(weatherURL: String, completion: @escaping ([(String, String, String, Double, String)]) -> Void) {
            performRequestCalled = true
            lastRequestedURL = weatherURL
            completion(mockData)
        }
        
        func parseJSON(weatherData: Data) -> [(String, String, String, Double, String)]? {
            parseJSONCalled = true
            return mockData
        }
}
