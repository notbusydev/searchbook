//
//  BookDetailTests.swift
//  itbookTests
//
//  Created by JaeBin on 2023/01/13.
//

import XCTest
@testable import itbook

final class BookDetailTests: XCTestCase {
    var viewController: BookDetailViewController!
    var viewModel: MockSearchBooksViewModel!
    var resositoryStub: BookRepositoryStub!
    var navigator: MockBookDetailNavigator!
    override func setUpWithError() throws {
        resositoryStub = BookRepositoryStub()
        navigator = MockBookDetailNavigator()
        viewController = BookDetailViewController.instantiate(.Main)
        viewController.viewModel = BookDetailViewModel(navigator: navigator, model: BookDetailModel(isbn13: "1234567891234"), respository: resositoryStub)
        viewController.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
        viewController.view.layoutIfNeeded()
        
    }

    func test_로딩() {
        
        let expectation = expectation(description: "로딩")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(viewController.indicatorView.isAnimating)
        XCTAssertTrue(viewController.contentView.isHidden)
    }
    
    func test_API_에러() {
        resositoryStub.bookParameter?.completion(.error(BookRepository.RequestError.nonIsbn13))
        XCTAssertEqual(navigator.message, BookRepository.RequestError.nonIsbn13.localizedDescription)
        
    }
    
    func test_화면() {
        let book = BookResponse(title: "스위프트",
                                    subtitle: "스위프트를 위하여",
                                    authors: "작성자",
                                    publisher: "출판사",
                                    isbn10: "ISBN101234",
                                    isbn13: "ISBN131234567",
                                    pages: "230",
                                    year: "2023",
                                    rating: "4.5",
                                    desc: "참 잘만든 책입니다.",
                                    price: "$4.5",
                                    image: "",
                                    url: "https://itbook.store/books/1001664382115",
                                    language: "korean",
                                    pdf: ["Free eBook":"https://www.dbooks.org/d/5664311152-1664381838-02962ae799d58d32/"])
        resositoryStub.bookParameter?.completion(.success(book))
        
        let expectation = expectation(description: "화면")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        XCTAssertTrue(!viewController.indicatorView.isAnimating)
        XCTAssertTrue(!viewController.contentView.isHidden)
        XCTAssertEqual(viewController.titleLabel.text, book.title)
        XCTAssertEqual(viewController.subTitleLabel.text, book.subtitle)
        XCTAssertEqual(viewController.authorLabel.text, String(format: "저자: %@", book.authors))
        XCTAssertEqual(viewController.publisherLabel.text, String(format: "출판사: %@", book.publisher))
        XCTAssertEqual(viewController.yearLabel.text, String(format: "출판년도: %@", book.year))
        XCTAssertEqual(viewController.pagesLabel.text, String(format: "페이지: %@", book.pages))
        XCTAssertEqual(viewController.languageLabel.text, String(format: "언어: %@", book.language))
        XCTAssertEqual(viewController.ratingLabel.text, String(format: "별점: %@", book.rating ?? "0"))
        XCTAssertEqual(viewController.isbn10Label.text, String(format: "ISBN10: %@", book.isbn10))
        XCTAssertEqual(viewController.isbn13Label.text, String(format: "ISBN13: %@", book.isbn13))
        XCTAssertEqual(viewController.priceLabel.text, String(format: "가격: %@", book.price))
        XCTAssertEqual(viewController.descriptionLabel.text, String(format: "설명: %@", book.desc))
        if let pdfs = book.pdf {
            for key in pdfs.keys {
                let isContain = viewController.stackView.subviews.contains { ($0 as? UIButton)?.titleLabel?.text == key }
                XCTAssertTrue(isContain)
            }
        }
    }
    
    func test_PDF_Link() {
        let book = BookResponse(title: "스위프트",
                                    subtitle: "스위프트를 위하여",
                                    authors: "작성자",
                                    publisher: "출판사",
                                    isbn10: "ISBN101234",
                                    isbn13: "ISBN131234567",
                                    pages: "230",
                                    year: "2023",
                                    rating: "4.5",
                                    desc: "참 잘만든 책입니다.",
                                    price: "$4.5",
                                    image: "",
                                    url: "https://itbook.store/books/1001664382115",
                                    language: "korean",
                                    pdf: ["Free eBook":"https://www.dbooks.org/d/5664311152-1664381838-02962ae799d58d32/"])
        resositoryStub.bookParameter?.completion(.success(book))
        let expectation = expectation(description: "화면")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        let button = viewController.stackView.subviews[1] as! UIButton
        viewController.pdfLinkButtonTouched(sender: button)
        
        XCTAssertEqual(navigator.url, "https://www.dbooks.org/d/5664311152-1664381838-02962ae799d58d32/") 
    }
}
