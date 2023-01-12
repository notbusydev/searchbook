//
//  SearchBookNavigator.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import UIKit
import SafariServices

protocol SearchBookNavigator {
    func toAlert(_ message: String?)
    func toBookDetail(_ isbn13: String)
    func toWeb(_ url: URL)
}


class DefaultSearchBookNavigator: SearchBookNavigator {
    private let navigationController: UINavigationController
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func toAlert(_ message: String?) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        navigationController.present(alertController, animated: true)
    }
    
    func toBookDetail(_ isbn13: String) {
        navigationController.pushViewController(UIViewController(), animated: true)
    }
    
    func toWeb(_ url: URL) {
        navigationController.present(SFSafariViewController(url: url), animated: true)
    }
}
