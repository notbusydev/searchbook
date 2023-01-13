//
//  UIViewController+Extension.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit

extension UIViewController {
    enum StoryBoard: String {
        case Main
    }
    
    static func instantiate(_ storyboardName: StoryBoard) -> Self {
        let storyBoard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyBoard.instantiateViewController(withID: String(describing: self))
    }
}

fileprivate extension UIStoryboard {
    func instantiateViewController<T>(withID: String) -> T {
        return instantiateViewController(withIdentifier: withID) as! T
    }
}
