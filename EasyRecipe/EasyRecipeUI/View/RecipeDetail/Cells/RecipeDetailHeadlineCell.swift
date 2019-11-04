//
//  RecipeDetailHeadlineCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeDetailHeadlineCell: UITableViewCell {

    @IBOutlet weak var headlineLabel: UILabel! {
        didSet {
            headlineLabel.textColor = UIColor.systemGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension RecipeDetailHeadlineCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath: IndexPath,
                        tableViewController: UITableViewController) {
        headlineLabel.text = viewModel.headline
    }
    
    static var nibName: String {
        return "RecipeDetailHeadlineCell"
    }
}
