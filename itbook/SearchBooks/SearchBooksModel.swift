//
//  SearchBookModel.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation

class SearchBooksModel {
    var keyword: String = ""
    var currentPage: Int? = nil
    var totalCount: Int = 0
    var searchBook: [SearchBooksResponse.Book] = []
}
