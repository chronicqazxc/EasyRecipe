//
//  RecipeDetailSection.swift
//  EasyRecipeUI
//
//  Created by Wayne Hsiao on 2019/10/23.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

enum RecipeDetailSection {
    case recipeImage
    case title
    case headline
    case rating
    case description
    case ingredients
    case nutrition
    case sectionTitle
    
    /// 1. recipeImage
    /// 2. headline
    /// 3. rating
    /// 4. description
    /// 5. sectionTitle (Ingredients section title)
    static let numberOfFixedRowsBeforeIngredients = 5
    
    static let indexOfIngredientsSectionTitle = 4
}

extension RecipeDetailSection {
    
    static func registerCells(forTableView tableView: UITableView) {
        let recipeDetailImageCellNib = UINib(nibName: RecipeDetailImageCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailImageCellNib, forCellReuseIdentifier: RecipeDetailImageCell.nibName)
        
        let recipeDetailTitleCellNib = UINib(nibName: RecipeDetailTitleCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailTitleCellNib, forCellReuseIdentifier: RecipeDetailTitleCell.nibName)
        
        let recipeDetailHeadlineCellNib = UINib(nibName: RecipeDetailHeadlineCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailHeadlineCellNib, forCellReuseIdentifier: RecipeDetailHeadlineCell.nibName)
        
        let recipeDetailRatingCellNib = UINib(nibName: RecipeDetailRatingCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailRatingCellNib, forCellReuseIdentifier: RecipeDetailRatingCell.nibName)
        
        let recipeDetailDescriptionCellNib = UINib(nibName: RecipeDetailDescriptionCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailDescriptionCellNib, forCellReuseIdentifier: RecipeDetailDescriptionCell.nibName)
        
        let recipeDetailIngredientsCellNib = UINib(nibName: RecipeDetailIngredientsCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailIngredientsCellNib, forCellReuseIdentifier: RecipeDetailIngredientsCell.nibName)
        
        let recipeDetailNutritionCellNib = UINib(nibName: RecipeDetailNutritionInfoCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeDetailNutritionCellNib, forCellReuseIdentifier: RecipeDetailNutritionInfoCell.nibName)
        
        let recipeSectionTitleCellNib = UINib(nibName: RecipeSectionTitleCell.nibName, bundle: Resource.bundle)
        tableView.register(recipeSectionTitleCellNib, forCellReuseIdentifier: RecipeSectionTitleCell.nibName)
    }
    
    func cellForTableView(_ tableView: UITableView,
                          atIndexPath indexPath: IndexPath) -> RecipeDetailCell? {
        switch self {
        case .recipeImage:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailImageCell.nibName, for: indexPath) as? RecipeDetailImageCell {
                return cell
            }
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailTitleCell.nibName, for: indexPath) as? RecipeDetailTitleCell {
                return cell
            }
        case .headline:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailHeadlineCell.nibName, for: indexPath) as? RecipeDetailHeadlineCell {
                return cell
            }
        case .rating:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailRatingCell.nibName, for: indexPath) as? RecipeDetailRatingCell {
                return cell
            }
        case .description:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailDescriptionCell.nibName, for: indexPath) as? RecipeDetailDescriptionCell {
                return cell
            }
        case .ingredients:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientsCell.nibName, for: indexPath) as? RecipeDetailIngredientsCell {
                return cell
            }
        case .nutrition:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailNutritionInfoCell.nibName, for: indexPath) as? RecipeDetailNutritionInfoCell {
                return cell
            }
        case .sectionTitle:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeSectionTitleCell.nibName, for: indexPath) as? RecipeSectionTitleCell {
                return cell
            }
        }
        return nil
    }
}
