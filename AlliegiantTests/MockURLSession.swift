//
//  MockURLSession.swift
//  AlliegiantTests
//
//  Created by P10 on 12/07/24.
//

import Foundation

class MockURLSession: URLSession {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.nextData, self.nextResponse, self.nextError)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
