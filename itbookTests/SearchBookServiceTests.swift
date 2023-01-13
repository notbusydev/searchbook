//
//  SearchBookServiceTests.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import XCTest
@testable import itbook

final class SearchBookServiceTests: XCTestCase {

    func test검색_키워드() throws {
        let session = MockURLSession()
        let service = SearchBooksService(repository: BookRepository(session: session), currentModel: SearchBooksModel())
        
        service.search(keyword: "Hackspace 62", completion: { _ in })
        
        XCTAssertEqual(session.method, "GET")
        XCTAssertEqual(session.urlString, "https://api.itbook.store/1.0/search/Hackspace%2062/1")
        XCTAssertEqual(session.callCount, 1)
    }
    
    func test검색_더보기() throws {
        let session = MockURLSession()
        let model = SearchBooksModel()
        let service = SearchBooksService(repository: BookRepository(session: session), currentModel: model)
        model.keyword = "Hackspace 62"
        model.currentPage = 1
        
        service.more(completion: { _ in })
        
        XCTAssertEqual(session.method, "GET")
        XCTAssertEqual(session.urlString, "https://api.itbook.store/1.0/search/Hackspace%2062/2")
        XCTAssertEqual(session.callCount, 1)
    }
    
}

