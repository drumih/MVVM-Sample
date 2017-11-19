//
//  ArticleListService.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import ReactiveSwift
import Result

protocol ArticleListService {
    func getAllArticles() -> SignalProducer<[Article], AnyError>
}

class BaseArticleListService: ArticleListService {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func getAllArticles() -> SignalProducer<[Article], AnyError> {
        fatalError()
    }
}

class FakeArticleInfoViewModel: ArticleListService {
    func getAllArticles() -> SignalProducer<[Article], AnyError> {
        return SignalProducer(value: generateFakeArticles()).delay(2, on: QueueScheduler.main)
    }
    
    private func generateFakeArticles() -> [Article] {
        let url = URL(string: "http://topclassiccarsforsale.com/uploads/photoalbum/1982-porsche-911-sc-primo-condition-3.jpg")!
        let firstArticle = Article(title: "Article Title",
                                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                   date: Date(),
                                   iamgeURL: url)
        return [firstArticle]
    }
}
