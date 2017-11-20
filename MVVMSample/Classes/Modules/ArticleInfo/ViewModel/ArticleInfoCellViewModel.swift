//
//  ArticleInfoCellViewModel.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 20/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

class ArticleInfoCellViewModel {
    
    private(set) lazy var title: String  = { [unowned self] in self.article.title }()
    private(set) lazy var text: String   = { [unowned self] in self.article.text }()
    private(set) lazy var imageURL: URL? = { [unowned self] in self.article.iamgeURL }()
    
    private let article: Article
    
    required init(article: Article) {
        self.article = article
    }
}
