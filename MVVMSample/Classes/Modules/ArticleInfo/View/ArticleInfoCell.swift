//
//  ArticleInfoCellTableViewCell.swift
//  MVVMSample
//
//  Created by Andrey Mikhaylov on 20/11/2017.
//  Copyright © 2017 Andrey Mikhaylov. All rights reserved.
//

import UIKit
import TableKit

class ArticleInfoCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet var articleTextLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    
    private(set) var viewModel: ArticleInfoCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            articleTextLabel.text = viewModel.text
            
            if oldValue?.imageURL != viewModel.imageURL {
                articleImageView.image = nil
            }
            guard let imageURL = viewModel.imageURL else {
                return
            }
            articleImageView.kf.setImage(with: imageURL,
                                         options: [.transition(.fade(UIConstants.Animation.imageAppearanceTime))])
        }
    }
    
    func configure(with viewModel: ArticleInfoCellViewModel) {
        self.viewModel = viewModel
    }
}
