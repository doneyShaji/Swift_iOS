//
//  URLSessionProtocol.swift
//  Alliegiant
//
//  Created by P10 on 16/07/24.
//

import Foundation
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
