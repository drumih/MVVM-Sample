//
//  ArticleListViewModel.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ArticleListViewModel {

    var items: Property<[ArticleCellViewModel]> { get }
    var loadItems: Action<Void, [ArticleCellViewModel], AnyError> { get }
    func showArticleInfo(_ articleViewModel: ArticleCellViewModel)
}

class BaseListArticleViewModel: ArticleListViewModel {
    
    private let service: ArticleListService
    private let router: ArticleListRouter
    
    private(set) lazy var loadItems: Action<Void, [ArticleCellViewModel], AnyError> = self.setupLoadItemsAction()
    private(set) lazy var items: Property<[ArticleCellViewModel]> = self.setupItems()
    
    init(service: ArticleListService, router: ArticleListRouter) {
        self.service = service
        self.router = router
    }
    
    func showArticleInfo(_ articleViewModel: ArticleCellViewModel) {
        router.showArticleInfo(withArticle: articleViewModel.article)
    }
    
    // MARK: setup
    
    private func setupLoadItemsAction() -> Action<Void, [ArticleCellViewModel], AnyError> {
        return Action { [weak self] in
            guard let strongSelf = self else {
                return SignalProducer.empty
            }
            return strongSelf.service.getAllArticles().map { articles in
                articles.map { article in
                    ArticleCellViewModel(article: article)
                }
            }
        }
    }
    
    private func setupItems() -> Property<[ArticleCellViewModel]> {
        return Property(initial: [], then: loadItems.values)
    }
}
