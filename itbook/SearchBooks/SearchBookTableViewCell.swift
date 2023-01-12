//
//  SearchBookTableViewCell.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit

class SearchBookTableViewCell: UITableViewCell {
    @IBOutlet weak var thunailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var webLinkButton: UIButton!
    var webLinkAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        webLinkButton.addTarget(self, action: #selector(self.webLinkButtonTouched), for: .touchUpInside)
    }
    func initView(_ book: SearchBookRowViewModel) {
        thunailImageView.setImage(book.image)
        titleLabel.text = book.title
        if let subTitle = book.subTitle {
            subTitleLabel.text = subTitle
        }
        subTitleLabel.isHidden = book.subTitle == nil
        isbn13Label.text = book.isbn13
        priceLabel.text = book.price
    }
    
    @objc func webLinkButtonTouched() {
        webLinkAction?()
    }
}
