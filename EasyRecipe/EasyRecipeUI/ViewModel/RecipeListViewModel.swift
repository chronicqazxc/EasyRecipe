//
//  RecipeListViewModel.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import MyService
import EasyRecipeCore
import ProfileCore
import WHUIComponents

enum Callback {
    public typealias GetRecipeComplete = ([Recipe]?, Error?) -> Void
    public typealias GetImageComplete = ([IndexPath]) -> Void
}

public enum RecipeListViewModelError: Error {
    case getRecipesError
    case parseError
}

/// Ecapsulated the business logic of RecipeListViewController
public class RecipeListViewModel: RecipeViewModel {
    var coordinator: Coordinator?
    
    let service: RecipeService
    var items = [Recipe]()
    var pendingOperations = PendingIconDownloaderOperations()
    
    var getRecipeCallback: (Callback.GetRecipeComplete)?
    var getImageCallback: (Callback.GetImageComplete)?
    
    fileprivate var selectedIndex: IndexPath?
    var selectedRecipe: Recipe? {
        guard let index = selectedIndex?.row, index < items.count else {
            return nil
        }
        return items[index]
    }
    
    /// Designated initializer with necessary parameters.
    /// - Parameter callback: Inject callback logic if needed.
    /// - Parameter service: Inject the custom service.
    public init(service: RecipeService = Service.shared) {
        self.service = service
    }
    
    /// Get recipes by the service which adopted the RecipeService protocol.
    public func getRecipes() {
        service.getRecipes { [unowned self] (data, response, error) in
            guard let data = data else {
                getRecipeCallback?(nil, RecipeListViewModelError.getRecipesError)
                return
            }
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                self.items = recipes
                getRecipeCallback?(self.items, nil)
                self.pendingOperations = PendingIconDownloaderOperations(downloaders: self.downloadableIngredients())
            } catch {
                getRecipeCallback?(nil, RecipeListViewModelError.parseError)
            }
        }
    }
    
    func downloadableIngredients() -> [IconDownloader] {
        items.map { (recipe) -> IconDownloader in
            return IconDownloader(recipe)
        }
    }
    
    func startOperations(for appIconDownloader: IconDownloader, at indexPath: IndexPath) {
        pendingOperations.startDownload(for: appIconDownloader, at: indexPath) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if $0 == .finished {
                strongSelf.getImageCallback?([indexPath])
            }
        }
    }
    
    func scrollViewWillBeginDragging() {
        pendingOperations.suspendAllOperations()
    }
    
    func scrollViewDidEndDragging() {
        pendingOperations.resumeAllOperations()
    }
    
    func scrollViewDidEndDecelerating() {
        pendingOperations.resumeAllOperations()
    }
    
    func loadImagesForOnScreenCells(pathes: [IndexPath]) {
        pendingOperations.loadImagesForOnScreenCells(indexPathsForVisibleRows: pathes) { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getImageCallback?(pathes)
        }
    }
    
    public func loginOrGetRecipes() {
        if Profile.isLoggedIn == true {
            getRecipes()
        } else {
            coordinator?.navigateToNextPage()
        }
    }
    
    func recipeNameBy(indexPath: IndexPath) -> String {
        let recipe = items[indexPath.row]
        return recipe.name
    }
    
    func recipeHeadlineBy(indexPath: IndexPath) -> String {
        let recipe = items[indexPath.row]
        return recipe.headline
    }
    
    func recipeIsFavoritedBy(indexPath: IndexPath) -> Bool {
        let recipe = items[indexPath.row]
        return isFavorited(recipe)
    }
    
    func recipeRatingBy(indexPath: IndexPath) -> Int {
        if let rating = ratingForRecipeAt(indexPath: indexPath) {
            return rating
        } else {
            let recipe = items[indexPath.row]
            return recipe.averageRating
        }
    }
    
    func isRecipeBeenRatedBy(indexPath: IndexPath) -> Bool {
        return ratingForRecipeAt(indexPath: indexPath) != nil ? true : false
    }
    
    func tableView(didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        coordinator?.navigateToNextPage()
    }
    
    func ratingForRecipeAt(indexPath: IndexPath) -> Int? {
        let recipe = items[indexPath.row]
        return RatingCache.shared.ratingFor(identifier: recipe.id)
    }
}

extension RecipeListViewModel {
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return items.count
    }
}

extension RecipeListViewModel {
    func ratingButtonTapped(_ rating: Int, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let recipe = items[indexPath.row]
        RatingCache.shared.updateRating(rating, for: recipe.id)
    }
    
    func favoriteButtonTapped(indexPath: IndexPath?, completeHandler: (Bool)->Void) {
        
        guard let indexPath = indexPath,
            indexPath.row < items.count,
            let profile = Profile.current,
            let persistentAccount = PersistentHelper.persistentProfile(accountName(profile)) else {
                completeHandler(false)
                return
        }
        
        let recipe = items[indexPath.row]
        guard let persistentRecipe = PersistentHelper.persistentRecipe(recipe.id) else {
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
}
