//
//  RecipeDetailDescriptionCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeDetailDescriptionCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    override func prepareForReuse() {
        textView.text = ""
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

extension RecipeDetailDescriptionCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath: IndexPath,
                        tableViewController: UITableViewController) {
        textView.text = viewModel.recipeDescription
        textView.sizeToFit()
        textView.isEditable = false
        textView.isScrollEnabled = false
    }
    
    static var nibName: String {
        return "RecipeDetailDescriptionCell"
    }
}
