//
//  RecipeDetailViewModel.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import EasyRecipeCore
import ProfileCore
import WHUIComponents

public enum RecipeDetaiCallback {
    typealias IngredientImageCallback = ([IndexPath]) -> Void
    typealias RecipeImageCallback = (UIImage?) -> Void
}

/// Ecapsulated the business logic of RecipeDetailViewController
public class RecipeDetailViewModel: RecipeViewModel {
    var coordinator: Coordinator?
    var recipe: Recipe
    var pendingOperations: PendingIconDownloaderOperations
    var ingredientImageDownloadComplete: (RecipeDetaiCallback.IngredientImageCallback)?
    var recipeImageDownloadComplete: (RecipeDetaiCallback.RecipeImageCallback)?

    var items: [RecipeDetailSection] {
        var items: [RecipeDetailSection] = [
            .recipeImage,
            .headline,
            .rating,
            .description,
            .sectionTitle
        ]
        for _ in recipe.ingredients {
            items.append(.ingredients)
        }
        items.append(.sectionTitle)
        for _ in recipe.nutrition {
            items.append(.nutrition)
        }
        return items
    }
    
    var title: String {
        return recipe.name
    }
    
    var headline: String {
        return recipe.headline
    }
    
    var imageURL: String {
        return recipe.imageURL
    }
    
    public init(recipe: Recipe) {
        self.recipe = recipe
        let ingredientsDownloader = recipe.ingredients.map { (ingredient) in
            return IconDownloader(ingredient)
        }
        self.pendingOperations = PendingIconDownloaderOperations(downloaders: ingredientsDownloader)
    }
    
    var isFavorited: Bool {
        return isFavorited(recipe)
    }
    
    var recipeDescription: String {
        return recipe.description
    }
    
    func recipeIngredientsNameBy(indexPath: IndexPath) -> String {
        return ingredientBy(indexPath: indexPath).name
    }
    
    func recipeIngredientsImageLinkBy(indexPath: IndexPath) -> String {
        return ingredientBy(indexPath: indexPath).imageLink
    }
    
    func ingredientBy(indexPath: IndexPath) -> Ingredient {
        let ingredientIndex = ingredientIndexBy(indexPath: indexPath)
        let ingredient = recipe.ingredients[ingredientIndex]
        return ingredient
    }
    
    func ingredientIndexBy(indexPath: IndexPath) -> Int {
        return indexPath.row - RecipeDetailSection.numberOfFixedRowsBeforeIngredients
    }
    
    func nutritionNameBy(indexPath: IndexPath) -> String {
        return nutritionBy(indexPath: indexPath).name
    }
    
    func nutritionValueBy(indexPath: IndexPath) -> String {
        return String(nutritionBy(indexPath: indexPath).amount)
    }
    
    func nutritionUnitBy(indexPath: IndexPath) -> String {
        return nutritionBy(indexPath: indexPath).unit
    }
    
    func nutritionBy(indexPath: IndexPath) -> Nutrition {
        let ingredientIndex = nutritionIndexBy(indexPath: indexPath)
        let nutrition = recipe.nutrition[ingredientIndex]
        return nutrition
    }
    
    func nutritionIndexBy(indexPath: IndexPath) -> Int {
        return indexPath.row - RecipeDetailSection.numberOfFixedRowsBeforeIngredients - recipe.ingredients.count - 1
    }
    
    func sectionTitleBy(indexPath: IndexPath) -> String {
        if indexPath.row == RecipeDetailSection.indexOfIngredientsSectionTitle {
            return "Ingredients"
        } else if indexPath.row == RecipeDetailSection.numberOfFixedRowsBeforeIngredients + recipe.ingredients.count {
            return "Nutrition Info"
        }
        return ""
    }
    
    func downloadRecipeImage() {
        DispatchQueue.global().async {
            ImageCache.shared.downloadImage(url: self.recipe.imageURL) { (image) in
                self.recipeImageDownloadComplete?(image)
            }
        }
    }
    
    func recipeDetailSectionBy(indexPath: IndexPath) -> RecipeDetailSection {
        return items[indexPath.row]
    }
    
    func ratingForRecipe() -> Int {
        if let rating = RatingCache.shared.ratingFor(identifier: recipe.id) {
            return rating
        } else {
            return recipe.averageRating
        }
    }
    
    func isRecipeBeenRated() -> Bool {
        return RatingCache.shared.ratingFor(identifier: recipe.id) != nil ? true : false
    }
    
    func loadImagesForOnScreenCells(pathes: [IndexPath]) {
        pendingOperations.loadImagesForOnScreenCells(indexPathsForVisibleRows: pathes) { [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.ingredientImageDownloadComplete?(pathes)
        }
    }
    
    func recipeIngredientImageBy(indexPath: IndexPath) -> UIImage? {
        let appIconDownloader = recipeIconDownloaderBy(indexPath: indexPath)
        return appIconDownloader.image ?? Resource.dishImage
    }
    
    func recipeIconDownloaderBy(indexPath: IndexPath) -> IconDownloader {
        let ingredientIndex = ingredientIndexBy(indexPath: indexPath)
        let iconDownloader = pendingOperations[ingredientIndex]
        return iconDownloader
    }
    
    func startOperation(_ operation: IconDownloader, at indexPath: IndexPath) {
        pendingOperations.startDownload(for: operation, at: indexPath) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if $0 == .finished {
                strongSelf.ingredientImageDownloadComplete?([indexPath])
            }
        }
    }
}

extension RecipeDetailViewModel {

    func favoriteButtonTapped(completeHandler: (_ updateSuccess: Bool)->Void) {
        guard let profile = Profile.current,
            let persistentAccount = PersistentHelper.persistentProfile(accountName(profile)),
            let persistentRecipe = PersistentHelper.persistentRecipe(recipe.id) else {
                completeHandler(false)
                return
        }
        
        if persistentRecipe.favoritedBy?.contains(persistentAccount) == true {
            persistentRecipe.removeFromFavoritedBy(persistentAccount)
        } else {
            persistentRecipe.addToFavoritedBy(persistentAccount)
        }

        PersistentHelper.shared.save()
        
        completeHandler(true)
    }
    
    func ratingButtonTapped(rating: Int) {
        RatingCache.shared.updateRating(rating, for: recipe.id)
    }
}

extension RecipeDetailViewModel: TableViewModel {
    func tableView(didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return items.count
    }
}

extension RecipeDetailViewModel: ViewModelScrollable {
    func scrollViewWillBeginDragging() {
        pendingOperations.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging() {
        pendingOperations.resumeAllOperations()
    }
    
    func scrollViewDidEndDecelerating() {
        pendingOperations.resumeAllOperations()
    }
}
