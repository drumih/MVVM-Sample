//
//  ArticleCellViewModel.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

class ArticleCellViewModel {
    
    let article: Article
    
    private(set) lazy var title: String = { [unowned self] in self.article.title }()
    private(set) lazy var text: String? = { [unowned self] in self.article.text }()
    private(set) lazy var dateText: String? = self.setupDateText()
    private(set) lazy var imageURL: URL? = { [unowned self] in self.article.iamgeURL }()
    
    init(article: Article) {
        self.article = article
    }
    
    private func setupDateText() -> String? {
        return DateFormatter.stringFromDate(article.date, dateFormat: .numericDateAndTime)
    }
}
