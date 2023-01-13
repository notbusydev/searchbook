//
//  BookResponse.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation
struct BookResponse: Decodable {
    let title: String
    let subtitle: String?
    let authors: String
    let publisher: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String?
    let desc: String
    let price: String
    let image: String
    let url: String
    let language: String
    let pdf: [String: String]?
}
