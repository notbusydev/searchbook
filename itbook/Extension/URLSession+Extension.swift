//
//  URLSession+Extension.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return self.dataTask(with: request, completionHandler: completionHandler)
    }
    
    
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }


