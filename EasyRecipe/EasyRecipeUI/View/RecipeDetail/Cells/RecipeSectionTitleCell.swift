//
//  RecipeSectionTitleCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/9.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeSectionTitleCell: UITableViewCell {

    @IBOutlet weak var recipeSectionTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecipeSectionTitleCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath indexPath: IndexPath,
                        tableViewController: UITableViewController) {
        recipeSectionTitleLabel.text = viewModel.sectionTitleBy(indexPath: indexPath)
    }
    
    static var nibName: String {
        return "RecipeSectionTitleCell"
    }
}
