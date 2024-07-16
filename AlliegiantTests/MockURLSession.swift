//
//  MockURLSession.swift
//  AlliegiantTests
//
//  Created by P10 on 15/07/24.
//

import Foundation
@testable import Alliegiant

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        task.completionHandler = {
            completionHandler(self.data, nil, self.error)
        }
        return task
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (() -> Void)?
    
    override func resume() {
        completionHandler?()
    }
}
