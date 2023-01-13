//
//  SearchBooksTests.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import XCTest
@testable import itbook

final class SearchBooksTests: XCTestCase {
    var viewController: SearchBooksViewController!
    var repository: BookRepositoryStub!
    var navigator: MockSearchBooksNavigator!
    override func setUpWithError() throws {
        repository = BookRepositoryStub()
        navigator = MockSearchBooksNavigator()
        let viewModel = SearchBooksViewModel(service: SearchBooksService(repository: repository, currentModel: SearchBooksModel()), navigator: navigator)
        viewController = SearchBooksViewController.instantiate(.Main)
        viewController.viewModel = viewModel
        viewController.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
        viewController.view.layoutIfNeeded()
        
    }

    func test검색_서치바_검색() throws {
        viewController.searchBar.text = "Swift"
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        
        let expectation = expectation(description: "검색_서치바_검색")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(repository.searchParameter?.keyword, "Swift")
        XCTAssertTrue(viewController.indicatorView.isAnimating)
        XCTAssertTrue(viewController.tableView.isHidden)
    }
    
    func test검색_서치바_빈값() throws {
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        
        XCTAssertEqual(navigator.message, "검색어를 입력해주세요.")
    }
    
    func test검색결과_표시_기본() throws {
        viewController.searchBar.text = "책"
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        let book0 = SearchBooksResponse.Book(title: "첫번째 책", subtitle: "첫번째 책 너무 좋다", isbn13: "ISBN131234567", price: "$4.5", image: nil, url: "https://itbook.store/books/ISBN131234567")
        let book1 = SearchBooksResponse.Book(title: "두번째 책", subtitle: nil, isbn13: "ISBN131234567", price: "$4.5", image: nil, url: "https://itbook.store/books/ISBN131234567")
        
        let response = SearchBooksResponse(total: "130", page: "1", books: [book0, book1])
        repository.searchParameter?.completion(.success(response))
        
        let expectation = expectation(description: "검색결과")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        viewController.tableView.numberOfRows(inSection: 0)
        let numberOfRows = viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 3)
        
        let cell0 = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SearchBookTableViewCell
        XCTAssertEqual(cell0.titleLabel.text, book0.title)
        XCTAssertEqual(cell0.subTitleLabel.text, book0.subtitle)
        XCTAssertEqual(cell0.isbn13Label.text, String(format: "ISBN13: %@", book0.isbn13))
        XCTAssertEqual(cell0.priceLabel.text, String(format: "가격: %@", book0.price))
        
        let cell1 = viewController.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SearchBookTableViewCell
        XCTAssertEqual(cell1.titleLabel.text, book1.title)
        XCTAssertTrue(cell1.subTitleLabel.isHidden)
        XCTAssertEqual(cell1.isbn13Label.text, String(format: "ISBN13: %@", book1.isbn13))
        XCTAssertEqual(cell1.priceLabel.text, String(format: "가격: %@", book1.price))
        

        let cell2 = viewController.tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        XCTAssertTrue(cell2 is ActivityIndicatorTableViewCell)
    }
    
    func test검색결과_표시_빈값() throws {
        viewController.searchBar.text = "책"
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        
        
        
        let response = SearchBooksResponse(total: "0", page: nil, books: [])
        repository.searchParameter?.completion(.success(response))
        
        let expectation = expectation(description: "검색결과")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(!viewController.indicatorView.isAnimating)
        XCTAssertTrue(viewController.tableView.isHidden)
        XCTAssertEqual(viewController.emptyLabel.text, "검색 결과가 없습니다.")
    }
    
    func test검색결과_선택_상세이동() throws {
        viewController.searchBar.text = "책"
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        let book0 = SearchBooksResponse.Book(title: "첫번째 책", subtitle: "첫번째 책 너무 좋다", isbn13: "ISBN131234567", price: "$4.5", image: nil, url: "https://itbook.store/books/ISBN131234567")
        
        let response = SearchBooksResponse(total: "130", page: "1", books: [book0])
        repository.searchParameter?.completion(.success(response))
        
        let expectation = expectation(description: "검색결과")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
        
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(navigator.isbn, book0.isbn13)
    }
    
    func test검색결과_웹링크_이동() throws {
        viewController.searchBar.text = "책"
        viewController.searchBarSearchButtonClicked(viewController.searchBar)
        let book0 = SearchBooksResponse.Book(title: "첫번째 책", subtitle: "첫번째 책 너무 좋다", isbn13: "ISBN131234567", price: "$4.5", image: nil, url: "https://itbook.store/books/ISBN131234567")
        
        let response = SearchBooksResponse(total: "130", page: "1", books: [book0])
        repository.searchParameter?.completion(.success(response))
        
        let expectation = expectation(description: "검색결과")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 1)
        
        
        let cell0 = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SearchBookTableViewCell
        cell0.webLinkButtonTouched()
        
        XCTAssertEqual(navigator.url, book0.url)
    }
}
