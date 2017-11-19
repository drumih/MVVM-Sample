//
//  ArticleListRouter.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

protocol ArticleListRouter {
    func showArticleInfo(withArticle article: Article)
}

class BaseArticleListRouter: Router, ArticleListRouter {
    func showArticleInfo(withArticle article: Article) {
        viewController?.performSegue(withIdentifier: "articleInfo", sender: nil) { segue in
            guard let destination = segue.destination as? ArticleInfoViewController else {
                fatalError("wrong destination \(segue.destination)")
            }
            destination.viewModel.setup(withArticle: article)
        }
    }
}
