//
//  BookRepositoryStub.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
@testable import itbook

class BookRepositoryStub: BookRepositoryProtocol {
    var searchParameter: (keyword: String, page: Int, completion: (itbook.Result<itbook.SearchBooksResponse>) -> Void)?
    var bookParameter: (isbn13: String, completion: (itbook.Result<itbook.BookResponse>) -> Void)?
    func search(keyword: String, page: Int, completion: @escaping (itbook.Result<itbook.SearchBooksResponse>) -> Void) {
        self.searchParameter = (keyword, page, completion)
    }
    
    func book(isbn13: String, completion: @escaping (itbook.Result<itbook.BookResponse>) -> Void) {
        self.bookParameter = (isbn13, completion)
    }
    
    
}
