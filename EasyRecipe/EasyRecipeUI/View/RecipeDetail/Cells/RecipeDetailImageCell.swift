//
//  RecipeDetailmageCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

protocol RecipeDetailImageCellDelegate: class {
    func favoriteButtonTapped(cell: RecipeDetailImageCell)
}

class RecipeDetailImageCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.layer.cornerRadius = 5.0
            recipeImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var favoriteButton: UIButton!
    weak var delegate: RecipeDetailImageCellDelegate?
    var isFavorite: Bool = false {
        didSet{
            favoriteButton.tintColor = isFavorite == true ? UIColor.systemRed : UIColor.systemGray
            favoriteButton.setTitleColor(favoriteButton.tintColor, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        favoriteButton.tintColor = isFavorite == true ? UIColor.systemRed : UIColor.systemGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.favoriteButtonTapped(cell: self)
    }
}

extension RecipeDetailImageCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath: IndexPath,
                        tableViewController: UITableViewController) {
        if let image = ImageCache.shared.objectFor(identifier: viewModel.imageURL) {
            recipeImageView?.image = image
        } else {
            recipeImageView?.image = Resource.dishImage
            viewModel.downloadRecipeImage()
        }
        delegate = tableViewController as? RecipeDetailImageCellDelegate
        isFavorite = viewModel.isFavorited
    }
    
    static var nibName: String {
        return "RecipeDetailmageCell"
    }
}
