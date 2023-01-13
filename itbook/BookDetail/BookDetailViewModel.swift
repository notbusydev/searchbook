//
//  BookDetailViewModel.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
class BookDetailViewModel: BookDetailViewModelProtocol {
    let navigator: BookDetailNavigator
    private let currentModel: BookDetailModel
    private let respository: BookRepositoryProtocol
    var onLoaded: (() -> Void)?
    var onIsLoadingUpdate: ((Bool) -> Void)?
    
    var bookInformation: BookInformation? {
        guard let book = currentModel.bookDetail else { return nil }
        return BookInformation(book)
    }
    
    init(navigator: BookDetailNavigator, model: BookDetailModel, respository: BookRepositoryProtocol) {
        self.navigator = navigator
        self.currentModel = model
        self.respository = respository
    }
    
    func loadBook() {
        onIsLoadingUpdate?(true)
        self.respository.book(isbn13: currentModel.isbn13) {[weak self] result in
            self?.onIsLoadingUpdate?(false)
            switch result {
            case .success(let value):
                self?.currentModel.bookDetail = value
                self?.onLoaded?()
            case .error(let error):
                self?.navigator.toAlert(error.localizedDescription)
            }
        }
    }
    
    func toWeb(_ urlString: String?) {
        if let url = urlString?.toURL {
            navigator.toWeb(url)
        } else {
            navigator.toAlert("URL이 유실되었습니다.")
        }
    }
    
    struct BookInformation {
        let title: String
        let subTitle: String?
        let imageURLString: String?
        let author: String
        let publisher: String
        let year: String
        let pages: String
        let language: String?
        let rating: String
        let webLink: String
        let isbn10: String
        let isbn13: String
        let price: String
        let description: String
        let pdfLinks: [PDFLink]
        init(_ book: BookResponse) {
            self.title = book.title
            self.subTitle = book.subtitle
            self.imageURLString = book.image
            self.author = String(format: "저자: %@", book.authors)
            self.publisher = String(format: "출판사: %@", book.publisher)
            self.year = String(format: "출판년도: %@", book.year)
            self.pages = String(format: "페이지: %@", book.pages)
            self.language = String(format: "언어: %@", book.language)
            self.rating = String(format: "별점: %@", book.rating ?? "0")
            self.isbn10 = String(format: "ISBN10: %@", book.isbn10)
            self.isbn13 = String(format: "ISBN13: %@", book.isbn13)
            self.price = String(format: "가격: %@", book.price)
            self.description = String(format: "설명: %@", book.desc)
            self.webLink = book.url
            if let pdfs = book.pdf {
                var tempLinks = [PDFLink]()
                for pdfKey in pdfs.keys {
                    if let link = pdfs[pdfKey] {
                        tempLinks.append((name: pdfKey, link: link))
                    }
                    
                }
                self.pdfLinks = tempLinks
            } else {
                pdfLinks = []
            }
        }
    }
}



