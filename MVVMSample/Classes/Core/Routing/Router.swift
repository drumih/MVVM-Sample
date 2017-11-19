//
//  Router.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit

class Router {
    weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
