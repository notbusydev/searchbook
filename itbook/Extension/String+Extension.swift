//
//  String+Extension.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import Foundation


extension String {
    var toInt: Int? {
        Int(self)
    }
    
    var toURL: URL? {
        URL(string: self)
    }
}
