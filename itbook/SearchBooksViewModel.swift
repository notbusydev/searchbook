//
//  SearchBooksViewModel.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation

class SearchBooksViewModel {
    var onItemListUpdated: (() -> Void)?
    var onIsLoadingUpdate: ((Bool) -> Void)?
    var itemList: [SearchBookRowItem] {
        let itemList = service.currentModel.searchBook.map { SearchBookRowItem.book(SearchBookRowViewModel($0)) }
        if let currentPage = service.currentModel.currentPage, currentPage * 10 < service.currentModel.totalCount {
            return itemList + [.loading]
        } else {
            return itemList
        }
    }
    private var isLoading: Bool = false {
        didSet {
            onIsLoadingUpdate?(isLoading)
        }
    }
    private let service: SearchBookService
    private let navigator: SearchBookNavigator
    init(service: SearchBookService, navigator: SearchBookNavigator) {
        self.service = service
        self.navigator = navigator
    }
    func search(_ keyword: String?) {
        guard let keyword = keyword, !keyword.isEmpty else {
            self.navigator.toAlert("검색어를 입력해주세요.")
            return
        }
        guard !isLoading else { return }
        isLoading = true
        service.search(keyword: keyword) { [weak self] error in
            self?.isLoading = false
            if let error = error {
                self?.navigator.toAlert(error.localizedDescription)
            } else {
                self?.onItemListUpdated?()
            }
        }
    }
    
    func more() {
        guard !isLoading else { return }
        isLoading = true
        service.more { [weak self] error in
            self?.isLoading = false
            if let error = error {
                self?.navigator.toAlert(error.localizedDescription)
            } else {
                self?.onItemListUpdated?()
            }
        }
    }
}
