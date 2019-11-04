//
//  RecipeListCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/7.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

protocol RecipeListCellDelegate: class {
    func favoriteButtonTapped(_ cell: RecipeListCell, indexPath: IndexPath?)
    func ratingButtonTapped(_ cell: RecipeListCell, indexPath: IndexPath?)
}

class RecipeListCell: UITableViewCell {
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.setTitle("♥︎", for: .normal)
        }
    }
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            recipeImageView.layer.cornerRadius = 5.0
            recipeImageView.layer.masksToBounds = true
        }
    }
    
    lazy var starButtons = [
        star1Button,
        star2Button,
        star3Button,
        star4Button
    ]
    
    var starButtonColor: UIColor {
        return isRated == true ? UIColor.systemGreen : UIColor.systemGray
    }
    
    weak var delegate: RecipeListCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        isRated = false
        favoriteButton.tintColor = isFavorite == true ? UIColor.systemRed : UIColor.systemGray
        setStarButtonColor()
        rating = 0
    }
    
    func setStarButtonColor() {
        starButtons.forEach { (button) in
            button?.setTitleColor(starButtonColor, for: .normal)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        delegate?.favoriteButtonTapped(self, indexPath: indexPath)
    }
    
    @IBAction func starTapped(_ sender: Any) {
        guard let button = sender as? UIButton,
            let index = starButtons.firstIndex(of: button) else {
            return
        }
        let newRating = index + 1
        if rating == newRating {
            rating = rating - 1
        } else {
            rating = newRating
        }
        isRated = true
        delegate?.ratingButtonTapped(self, indexPath: indexPath)
    }
    
    
    /// Used for tableView estimation height.
    static var height: CGFloat {
        return 278.0
    }
    
    var isFavorite: Bool = false {
        didSet {
            favoriteButton.tintColor = isFavorite == true ? UIColor.systemRed : UIColor.systemGray
        }
    }
    
    var isRated: Bool = false {
        didSet {
            starButtons.forEach { (button) in
                button?.setTitleColor(starButtonColor, for: .normal)
            }
        }
    }
    
    @Range(wrappedValue: 4, 0...4) var rating: Int {
        didSet {
            setRatingButtons(rating)
        }
    }
    
    func setRatingButtons(_ rating: Int) {
        for i in 0...starButtons.count - 1 {
            let button = starButtons[i]
            if i <= rating - 1 {
                button?.setTitle("★", for: .normal)
            } else {
                button?.setTitle("☆", for: .normal)
            }
            button?.setTitleColor(starButtonColor, for: .normal)
        }
    }

    func tableViewController(_ tableViewController: RecipeListCellDelegate & UITableViewController, cellForRowAt indexPath: IndexPath, viewModel: RecipeListViewModel) {
        titleLabel.text = viewModel.recipeNameBy(indexPath: indexPath)
        descriptionLabel.text = viewModel.recipeHeadlineBy(indexPath: indexPath)
        delegate = tableViewController
        
        let appIconDownloader = viewModel.pendingOperations[indexPath.row]
        recipeImageView.image = appIconDownloader.image ?? Resource.dishImage
        
        switch appIconDownloader.iconDownloadStatus {
        case .failed:
            break
        case .downloaded:
            break
        case .new:
            if !tableViewController.tableView.isDragging && !tableViewController.tableView.isDecelerating {
                viewModel.startOperations(for: appIconDownloader, at: indexPath)
            }
        }
        
        isFavorite = viewModel.recipeIsFavoritedBy(indexPath: indexPath)
        self.indexPath = indexPath
        rating = viewModel.recipeRatingBy(indexPath: indexPath)
        isRated = viewModel.isRecipeBeenRatedBy(indexPath: indexPath)
    }
}
