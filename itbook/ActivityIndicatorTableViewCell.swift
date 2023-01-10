//
//  ActivityIndicatorTableViewCell.swift
//  itbook
//
//  Created by JaeBin on 2023/01/10.
//

import UIKit

class ActivityIndicatorTableViewCell: UITableViewCell {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
