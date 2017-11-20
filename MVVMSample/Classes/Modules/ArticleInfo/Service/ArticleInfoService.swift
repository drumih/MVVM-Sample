//
//  ArticleInfoService.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 20/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol ArticleInfoService {
    func getArticle(byID identifier: String) -> SignalProducer<Article, AnyError>
}

class FakeArticleInfoService: ArticleInfoService {
    func getArticle(byID identifier: String) -> SignalProducer<Article, AnyError> {
        return SignalProducer(value: generateFakeArticle()).delay(2, on: QueueScheduler.main)
    }
    
    private func generateFakeArticle() -> Article {
        let url = URL(string: "http://topclassiccarsforsale.com/uploads/photoalbum/1982-porsche-911-sc-primo-condition-3.jpg")!
        let firstArticle = Article(identifier: "first",
                                   title: "Article Title",
                                   text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                   date: Date(),
                                   iamgeURL: url)
        return firstArticle
    }
}
