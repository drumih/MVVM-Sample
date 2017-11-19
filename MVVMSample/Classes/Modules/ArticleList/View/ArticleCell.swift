//
//  ArticleCell.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 19/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import Kingfisher
import TableKit



class ArticleCell: UITableViewCell, ConfigurableCell {
    
    private(set) var viewModel: ArticleCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            titleLabel.text = viewModel.title
            articleTextLabel.text = viewModel.text
            dateLabel.text = viewModel.dateText

            if oldValue?.imageURL != viewModel.imageURL {
                articelImageView.image = nil
            }
            guard let imageURL = viewModel.imageURL else {
                return
            }
            articelImageView.kf.setImage(with: imageURL,
                                         options: [.transition(.fade(UIConstants.Animation.imageAppearanceTime))])
        }
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var articleTextLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var articelImageView: UIImageView!
    
    func configure(with viewModel: ArticleCellViewModel) {
        self.viewModel = viewModel
    }
}
