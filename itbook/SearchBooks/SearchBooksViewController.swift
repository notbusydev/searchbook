//
//  SearchBooksViewController.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit
typealias SearchBookItem = SearchBooksViewModel.SearchBookItemViewModel
class SearchBooksViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!
    var viewModel: SearchBooksViewModel!
    
    var dataSource: UITableViewDiffableDataSource<Int,SearchBookRowItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBind()
    }
    
    func initView() {
        title = "검색"
        searchBar.placeholder = "입력 후 검색"
        searchBar.delegate = self
        tableView.delegate = self
        emptyLabel.text = "검색해주세요"
        tableView.isHidden = true
    }
    
    func initBind() {
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
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        
        viewModel.onItemListUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.isHidden = self.viewModel.emptyText != nil
                if let emptyText = self.viewModel.emptyText {
                    self.emptyLabel.text = emptyText
                } else {
                    var currentSnapshot = self.dataSource.snapshot()
                    currentSnapshot.deleteAllItems()
                    currentSnapshot.appendSections([0])
                    currentSnapshot.appendItems(self.viewModel.itemList, toSection: 0)
                    self.dataSource.apply(currentSnapshot)
                }
            }
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath), item != .loading {
            viewModel.detail(indexPath)
        }
        
        
    }
}

extension SearchBooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}





enum SearchBookRowItem: Hashable {
    case book(SearchBookItem)
    case loading
}
