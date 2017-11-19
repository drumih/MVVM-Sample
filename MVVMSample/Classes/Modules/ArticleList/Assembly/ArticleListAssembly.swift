//
//  ArticleListAssembly.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ArticleListAssembly: Assembly {
    func assemble(container: Container) {
        
        // service
        
        container.register(ArticleListService.self) { resolver in
//            let client = resolver.resolve(Client.self)!
//            return BaseArticleListService(client: client)
            FakeArticleInfoViewModel()
        }
        
        // router
        
        container.register(ArticleListRouter.self) { (_: Resolver, viewController: UIViewController) in
            BaseArticleListRouter(viewController: viewController)
        }
        
        // view model
        
        container.register(ArticleListViewModel.self) { (resolver: Resolver, viewController: UIViewController) in
            let service = resolver.resolve(ArticleListService.self)!
            let router = resolver.resolve(ArticleListRouter.self, argument: viewController)!
            return BaseListArticleViewModel(service: service, router: router)
        }
        
        // view controller
        
        container.storyboardInitCompleted(ArticleListViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ArticleListViewModel.self, argument: controller as UIViewController)
        }
    }
}
