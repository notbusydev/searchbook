//
//  MockSearchBooksNavigator.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
@testable import itbook

class MockSearchBooksNavigator: SearchBooksNavigator {
    var isbn: String?
    var message: String?
    var url: String?
    func toAlert(_ message: String?) {
        self.message = message
    }
    
    func toBookDetail(_ isbn13: String) {
        self.isbn = isbn13
    }
    
    func toWeb(_ url: URL) {
        self.url = url.absoluteString
    }
}
