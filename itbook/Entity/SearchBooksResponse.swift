//
//  SearchResponse.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation
struct SearchBooksResponse: Decodable {
    let total: String
    let page: String?
    let books: [Book]
    
    struct Book: Decodable {
        let title: String
        let subtitle: String?
        let isbn13: String
        let price: String
        let image: String?
        let url: String
    }
}
