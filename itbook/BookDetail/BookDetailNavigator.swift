//
//  BookDetailNavigator.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import UIKit
import SafariServices

protocol BookDetailNavigator {
    func toWeb(_ url: URL)
    func toAlert(_ message: String)
}

class DefaultBookDetailNavigator: BookDetailNavigator {
    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func toWeb(_ url: URL) {
        navigationController.present(SFSafariViewController(url: url), animated: true)
    }
    
    func toAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        navigationController.present(alertController, animated: true)
    }
}
