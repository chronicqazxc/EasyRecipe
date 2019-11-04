//
//  RecipeDetailIngredientsCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class RecipeDetailIngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecipeDetailIngredientsCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath indexPath: IndexPath,
                        tableViewController: UITableViewController) {
        
        ingredientName.text = viewModel.recipeIngredientsNameBy(indexPath: indexPath)
        ingredientImageView.image = viewModel.recipeIngredientImageBy(indexPath: indexPath)
        ingredientImageView.contentMode = .scaleAspectFill
        
        let appIconDownloader = viewModel.recipeIconDownloaderBy(indexPath: indexPath)
        
        switch appIconDownloader.iconDownloadStatus {
        case .failed:
            break
        case .downloaded:
            break
        case .new:
            if !tableViewController.tableView.isDragging && !tableViewController.tableView.isDecelerating {
                viewModel.startOperation(appIconDownloader, at: indexPath)
            }
        }
        
    }
    
    static var nibName: String {
        return "RecipeDetailIngredientsCell"
    }
}
