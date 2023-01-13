//
//  BookDetailViewController.swift
//  itbook
//
//  Created by JaeBin on 2023/01/13.
//

import UIKit

protocol BookDetailViewModelProtocol {
    var onLoaded: (() -> Void)? { get set }
    var onIsLoadingUpdate: ((Bool) -> Void)? { get set }
    var bookInformation: BookDetailViewModel.BookInformation? { get }
    
    func loadBook()
    func toWeb(_ urlString: String?)
}

typealias PDFLink = (name: String, link: String)
class BookDetailViewController: UIViewController {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var webLinkButton: UIButton!
    @IBOutlet weak var isbn10Label: UILabel!
    @IBOutlet weak var isbn13Label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    var viewModel: BookDetailViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBind()
    }
    
    func initView() {
        contentView.isHidden = true
        webLinkButton.addTarget(self, action: #selector(self.webLinkButtonTouched), for: .touchUpInside)
    }
    
    func initBind() {
        viewModel.onIsLoadingUpdate = { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.indicatorView.startAnimating()
                } else {
                    self.indicatorView.stopAnimating()
                }
            }
        }
        viewModel.onLoaded = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.contentView.isHidden = false
                let information = self.viewModel.bookInformation
                self.title = information?.title
                self.titleLabel.text = information?.title
                self.subTitleLabel.text = information?.subTitle
                self.bookImageView.setImage(information?.imageURLString)
                self.authorLabel.text = information?.author
                self.publisherLabel.text = information?.publisher
                self.yearLabel.text = information?.year
                self.pagesLabel.text = information?.pages
                self.languageLabel.text = information?.language
                self.ratingLabel.text = information?.rating
                self.priceLabel.text = information?.price
                self.isbn10Label.text = information?.isbn10
                self.isbn13Label.text = information?.isbn13
                self.descriptionLabel.text = information?.description
                self.addPDFLinksButton(information?.pdfLinks)
            }
        }
        
        viewModel.loadBook()
    }
    
    func addPDFLinksButton(_ links: [PDFLink]?) {
        guard let links = links else { return }
        for (index, link) in links.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(link.name, for: .normal)
            button.addTarget(self, action: #selector(self.pdfLinkButtonTouched(sender:)), for: .touchUpInside)
            button.tag = index
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func webLinkButtonTouched() {
        viewModel.toWeb(viewModel.bookInformation?.webLink)
    }
    
    @objc func pdfLinkButtonTouched(sender: UIButton) {
        viewModel.toWeb(viewModel.bookInformation?.pdfLinks[sender.tag].link)
    }
}
