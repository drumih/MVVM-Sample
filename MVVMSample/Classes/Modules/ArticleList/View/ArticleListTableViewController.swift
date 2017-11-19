//
//  ArticleListTableViewController.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import ReactiveCocoa
import TableKit

class ArticleListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var refreshControll: UIRefreshControl!
    
    var viewModel: ArticleListViewModel! //injectable
    
    private var tableDirector: TableDirector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableDirector()
        setupRefreshControll()
        setupFlow()
        
        viewModel.loadItems.apply().start()
    }
    
    
    private func clickArticleAction() -> TableRowAction<ArticleCell> {
        return TableRowAction<ArticleCell>(.click) { [weak self] data in
            self?.viewModel.showArticleInfo(data.item)
        }
    }
    
    // MARK: table director
    
    private func setupView() {
        navigationItem.title = LocalizedString(forKey: "main.articles.title")
    }
    
    private func setupFlow() {
        viewModel.items
            .producer
            .map { [weak self] articleViewModels in
                articleViewModels.map { articleViewModel -> Row in
                    let clickAction = self?.clickArticleAction()
                    let actions: [TableRowAction<ArticleCell>] = clickAction.flatMap { [$0] } ?? []
                    return TableRow<ArticleCell>(item: articleViewModel, actions: actions)
                }
            }
            .map { TableSection(rows: $0) }
            .startWithValues { [weak self] section in
                self?.tableDirector.clear()
                self?.tableDirector += section
                self?.tableDirector.reload()
        }
    }
    
    private func setupTableDirector() {
        self.tableDirector = TableDirector(tableView: tableView)
    }
    private func setupRefreshControll() {
        refreshControll = UIRefreshControl()
        tableView.addSubview(refreshControll)
        refreshControll.reactive.refresh = CocoaAction<UIRefreshControl>(viewModel.loadItems)
    }
}
