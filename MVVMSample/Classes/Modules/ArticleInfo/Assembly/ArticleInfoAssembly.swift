//
//  ArticleInfoAssembly.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 20/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ArticleInfoAssembly: Assembly {
    
    func assemble(container: Container) {
        
        //service
        container.register(ArticleInfoService.self) { _ in
            FakeArticleInfoService()
        }
        
        //view model
        container.register(ArticleInfoViewModel.self) { resolver in
            let service = resolver.resolve(ArticleInfoService.self)!
            return BaseArticleInfoViewModel(service: service)
        }
        
        //view controller
        container.storyboardInitCompleted(ArticleInfoViewController.self) { resolver, viewController in
            viewController.viewModel = resolver.resolve(ArticleInfoViewModel.self)
        }
    }
}
