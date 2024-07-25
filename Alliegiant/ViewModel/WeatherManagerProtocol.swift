//
//  WeatherManagerProtocol.swift
//  Alliegiant
//
//  Created by P10 on 15/07/24.
//

import Foundation

protocol WeatherManagerProtocol {
    func fetchData(for category: String, completion: @escaping ([(String, String, String, Double, String, [String])]) -> Void)
    func performRequest(weatherURL: String, completion: @escaping ([(String, String, String, Double, String, [String])]) -> Void)
    func parseJSON(weatherData: Data) -> [(String, String, String, Double, String, [String])]?
}
