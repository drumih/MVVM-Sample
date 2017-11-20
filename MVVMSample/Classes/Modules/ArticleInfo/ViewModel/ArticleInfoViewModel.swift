//
//  ArticleInfoViewModel.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ArticleInfoViewModel {
    func setup(withArticle article: Article)
    
    var loadArticle: Action <Void, ArticleInfoCellViewModel, AnyError> { get } //first parametr is identifier
    var articleViewModel: Property<ArticleInfoCellViewModel?> { get }
    var title: Property<String?> { get }
}

class BaseArticleInfoViewModel: ArticleInfoViewModel {
    
    private let service: ArticleInfoService
    private(set) lazy var loadArticle: Action <Void, ArticleInfoCellViewModel, AnyError> = self.setupLoadArticle()
    private(set) lazy var articleViewModel: Property<ArticleInfoCellViewModel?>  = self.setupArticleViewModel()
    private(set) lazy var title: Property<String?> = setupTitleProperty()
    
    private var article: Article?
    
    required init(service: ArticleInfoService) {
        self.service = service
    }
    
    func setup(withArticle article: Article) {
        self.article = article
    }
    
    // MARK: setup
    
    private func setupLoadArticle() -> Action <Void, ArticleInfoCellViewModel, AnyError> {
        return Action { [weak self] identifier in
            guard let strongSelf = self, let identifier = self?.article?.identifier else {
                return SignalProducer.empty
            }
            return strongSelf.service.getArticle(byID: identifier).map { ArticleInfoCellViewModel(article: $0) }
        }
    }
    
    private func setupArticleViewModel() -> Property<ArticleInfoCellViewModel?> {
        let initial: ArticleInfoCellViewModel? = article.flatMap { ArticleInfoCellViewModel(article: $0) }
        let articlesSignal = loadArticle.values.map { Optional($0) }
        return Property(initial: initial, then: articlesSignal)
    }
    
    private func setupTitleProperty() -> Property<String?> {
        return articleViewModel.map { $0?.title }
    }
}
