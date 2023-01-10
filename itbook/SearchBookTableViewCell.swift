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
    
    func initView(_ book: SearchBookRowViewModel) {
        thunailImageView.setImage(book.image)
        titleLabel.text = book.title
        subTitleLabel.text = book.subTitle
        isbn13Label.text = book.isbn13
        priceLabel.text = book.price
    }
}
