//
//  BookDetailNavigator.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
@testable import itbook
class MockBookDetailNavigator: BookDetailNavigator {
    var url: String?
    var message: String?
    func toWeb(_ url: URL) {
        self.url = url.absoluteString
    }
    
    func toAlert(_ message: String) {
        self.message = message
    }
    
    
}
