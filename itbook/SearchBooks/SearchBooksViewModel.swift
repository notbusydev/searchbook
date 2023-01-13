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
        let itemList = service.currentModel.searchBook.map { SearchBookRowItem.book(SearchBookItemViewModel($0)) }
        if let currentPage = service.currentModel.currentPage, currentPage * 10 < service.currentModel.totalCount {
            return itemList + [.loading]
        } else {
            return itemList
        }
    }
    
    var emptyText: String? {
        guard !service.currentModel.keyword.isEmpty && service.currentModel.searchBook.isEmpty else { return nil }
        return "검색 결과가 없습니다."
    }
    private var isLoading: Bool = false
    private let service: SearchBooksService
    private let navigator: SearchBooksNavigator
    init(service: SearchBooksService, navigator: SearchBooksNavigator) {
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
        onIsLoadingUpdate?(true)
        service.search(keyword: keyword) { [weak self] error in
            self?.isLoading = false
            self?.onIsLoadingUpdate?(false)
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
    
    func link(_ urlString: String) {
        if let url = urlString.toURL {
            self.navigator.toWeb(url)
        } else {
            self.navigator.toAlert("링크가 유실되었습니다.")
        }
    }
    
    func detail(_ indexPath: IndexPath) {
        self.navigator.toBookDetail(service.currentModel.searchBook[indexPath.row].isbn13)
    }
    
    struct SearchBookItemViewModel: Hashable {
        let title: String
        let subTitle: String?
        let isbn13: String
        let price: String
        let urlString: String
        let image: String?
        
        init(_ book: SearchBooksResponse.Book) {
            image = book.image
            title = book.title
            subTitle = book.subtitle
            isbn13 = String(format: "ISPN13: %@", book.isbn13)
            price = String(format: "가격: %@", book.price)
            urlString = book.url
        }
    }
}
