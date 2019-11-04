//
//  RecipeDetailNutritionInfoCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeDetailNutritionInfoCell: UITableViewCell {

    @IBOutlet weak var nutritionNameLabel: UILabel!
    @IBOutlet weak var nutritionValueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecipeDetailNutritionInfoCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath indexPath: IndexPath,
                        tableViewController: UITableViewController) {
        nutritionNameLabel.text = viewModel.nutritionNameBy(indexPath: indexPath)
        nutritionValueLabel.text = "\(viewModel.nutritionValueBy(indexPath: indexPath)) \(viewModel.nutritionUnitBy(indexPath: indexPath))"
    }
    
    static var nibName: String {
        return "RecipeDetailNutritionInfoCell"
    }
}
