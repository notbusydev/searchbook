//
//  SearchBookService.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation

class SearchBooksService {
    let repository: BookRepositoryProtocol
    private(set) var currentModel: SearchBooksModel
    init(repository: BookRepositoryProtocol, currentModel: SearchBooksModel) {
        self.repository = repository
        self.currentModel = currentModel
    }
    
    func search(keyword: String, completion: @escaping (Error?) -> Void) {
        repository.search(keyword: keyword, page: 1) { [weak self] result in
            switch result {
            case .success(let value):
                self?.currentModel.searchBook = value.books
                self?.currentModel.keyword = keyword
                self?.currentModel.currentPage = value.page?.toInt ?? 0
                self?.currentModel.totalCount = Int(value.total) ?? 0
                completion(nil)
            case .error(let error):
                completion(error)
            }
        }
    }
    
    func more(completion: @escaping (Error?) -> Void) {
        guard let currentPage = currentModel.currentPage else { return }
        let keyword = currentModel.keyword
        let currentBooks = currentModel.searchBook
        repository.search(keyword: keyword, page: currentPage + 1) { [weak self] result in
            switch result {
            case .success(let value):
                self?.currentModel.searchBook = currentBooks + value.books
                self?.currentModel.keyword = keyword
                self?.currentModel.currentPage = value.page?.toInt
                self?.currentModel.totalCount = Int(value.total) ?? 0
                completion(nil)
            case .error(let error):
                completion(error)
            }
        }
    }
}
