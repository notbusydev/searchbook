//
//  MockURLSession.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
@testable import itbook
class MockURLSession: URLSessionProtocol {
    var method: String? = nil
    var urlString: String? = nil
    var callCount: Int = 0
    func dataTask(request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        urlString = request.url?.absoluteString
        method = request.httpMethod
        return FakeURLSessionDataTask { [weak self] in
            self?.callCount += 1
            completionHandler(nil,nil,nil)
        }
    }
    class FakeURLSessionDataTask: URLSessionDataTaskProtocol {
        var onCallResume: (()->Void)
        init(onCallResume: @escaping () -> Void) {
            self.onCallResume = onCallResume
        }
        func resume() {
            onCallResume()
        }
    }
}
