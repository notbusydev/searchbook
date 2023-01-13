//
//  Utility.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit


class CacheManager {
    static let shared = NSCache<NSString, UIImage>()
}


extension UIImageView {
    func setImage(_ urlString: String?) {
        self.image = nil
        guard let urlString = urlString else { return }
        DispatchQueue.global(qos: .background).async { [weak self] in

            let key = NSString(string: urlString)
            if let cachedImage = CacheManager.shared.object(forKey: key) {
                DispatchQueue.main.async {
                    self?.image = cachedImage
                }
            } else {
                guard let url = URL(string: urlString) else { return }
                URLSession.shared.dataTask(with: url) { (data, result, error) in
                    let downloadImage: UIImage?
                    if let data = data, let image = UIImage(data: data) {
                        CacheManager.shared.setObject(image, forKey: key)
                        downloadImage = image
                    } else {
                        downloadImage = nil
                    }
                    
                    DispatchQueue.main.async {
                        self?.image = downloadImage
                    }
                }.resume()
            }
        }
    }
}
