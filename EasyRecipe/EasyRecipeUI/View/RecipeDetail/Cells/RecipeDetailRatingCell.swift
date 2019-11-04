//
//  RecipeDetailRatingCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

protocol RecipeDetailRatingCellDelegate: class {
    func starButtonTapped(_ cell: RecipeDetailRatingCell)
}

class RecipeDetailRatingCell: UITableViewCell {

    weak var delegate: RecipeDetailRatingCellDelegate?

    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    
    lazy var starButtons = [
        star1Button,
        star2Button,
        star3Button,
        star4Button
    ]
    
    var starButtonColor: UIColor {
        return isRated == true ? UIColor.systemGreen : UIColor.systemGray
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
        isRated = false
        setStarButtonColor()
        rating = 0
    }
    
    @IBAction func starButtonTapped(_ sender: Any) {
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
        delegate?.starButtonTapped(self)
    }
    
    var isRated: Bool = false {
        didSet {
            starButtons.forEach { (button) in
                button?.setTitleColor(starButtonColor, for: .normal)
            }
        }
    }
    
    func setStarButtonColor() {
        starButtons.forEach { (button) in
            button?.setTitleColor(starButtonColor, for: .normal)
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
}

extension RecipeDetailRatingCell: RecipeDetailCell {
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath: IndexPath,
                        tableViewController: UITableViewController) {
        delegate = tableViewController as? RecipeDetailRatingCellDelegate
        rating = viewModel.ratingForRecipe()
        isRated = viewModel.isRecipeBeenRated()
    }
    
    static var nibName: String {
        return "RecipeDetailRatingCell"
    }
}
