//
//  BookDetailModel.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import Foundation
class BookDetailModel {
    let isbn13: String
    var bookDetail: BookResponse?
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
}
