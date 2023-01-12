//
//  SearchBooksViewController.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit

class SearchBooksViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var viewModel: SearchBooksViewModel!
    
    var dataSource: UITableViewDiffableDataSource<Int,SearchBookRowItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBind()
    }
    
    func initView() {
        title = "검색"
        searchBar.delegate = self
        tableView.delegate = self
        
        let cellProvider: (UITableView, IndexPath, SearchBookRowItem) -> UITableViewCell? = { tableView, indexPath, item in
            switch item {
            case .book(let value):
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookTableViewCell", for: indexPath) as! SearchBookTableViewCell
                cell.initView(value)
                cell.webLinkAction = { [weak self] in
                    self?.viewModel.link(value.urlString)
                }
                return cell
            case .loading:
                return tableView.dequeueReusableCell(withIdentifier: "ActivityIndicatorTableViewCell", for: indexPath)
            }
        }
        dataSource = UITableViewDiffableDataSource<Int, SearchBookRowItem>(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
    }
    
    func initBind() {
        viewModel.onItemListUpdated = { [weak self] in
            guard let self = self else { return }
            var currentSnapshot = self.dataSource.snapshot()
            currentSnapshot.deleteAllItems()
            currentSnapshot.appendSections([0])
            currentSnapshot.appendItems(self.viewModel.itemList, toSection: 0)
            self.dataSource.apply(currentSnapshot)
        }
        
        viewModel.onIsLoadingUpdate = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.indicatorView.startAnimating()
                } else {
                    self?.indicatorView.stopAnimating()
                }
            }
        }
        
    }
}

extension SearchBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.itemList[indexPath.row] == .loading {
            viewModel.more()
        }
    }
}

extension SearchBooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(searchBar.text)
    }
}


struct SearchBookRowViewModel: Hashable {
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
        price = String(format: "Price: %@", book.price)
        urlString = book.url
    }
}


enum SearchBookRowItem: Hashable {
    case book(SearchBookRowViewModel)
    case loading
}
