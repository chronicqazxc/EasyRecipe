//
//  RecipeDetailTitleCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeDetailTitleCell: UITableViewCell {

    @IBOutlet weak var recipeTitleLabel: UILabel!
    
    var title: String = "" {
        didSet {
            recipeTitleLabel.text = title
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
    
    override func prepareForReuse() {
        title = ""
    }
    
}

extension RecipeDetailTitleCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath: IndexPath,
                        tableViewController: UITableViewController) {
        title = viewModel.title
    }
    
    static var nibName: String {
        return "RecipeDetailTitleCell"
    }
}
