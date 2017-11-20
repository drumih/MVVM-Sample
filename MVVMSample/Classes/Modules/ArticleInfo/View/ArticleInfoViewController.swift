//
//  ArticleInfoViewController.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import TableKit
import ReactiveCocoa
import ReactiveSwift

class ArticleInfoViewController: UIViewController {
    
    var viewModel: ArticleInfoViewModel!
    
    @IBOutlet var tableView: UITableView!
    private var tableDirector: TableDirector!
    private var refreshControll: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableDirector()
        setupRefreshControll()
        setupFlow()
        
        viewModel.loadArticle.apply().start()
    }
    
    // MARK: setup
    
    private func setupView() {
        navigationItem.reactive.title <~ viewModel.title
        tableView.separatorStyle = .none
    }
    
    private func setupTableDirector() {
        tableDirector = TableDirector(tableView: tableView)
    }
    
    private func setupRefreshControll() {
        refreshControll = UIRefreshControl()
        tableView.addSubview(refreshControll)
        refreshControll.reactive.refresh = CocoaAction<UIRefreshControl>(viewModel.loadArticle)
    }
    
    private func setupFlow() {
        viewModel.articleViewModel
            .producer
            .skipNil()
            .map { TableRow<ArticleInfoCell>(item: $0) }
            .startWithValues { [weak self] row in
                self?.tableDirector.clear()
                self?.tableDirector += row
                self?.tableDirector.reload()
            }
    }
    
}
