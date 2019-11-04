//
//  AccountWrapper.swift
//  CoreDataDemo
//
//  Created by Hsiao, Wayne on 2019/10/3.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

/// As a abstract interface which intended to hide the concrete Persistent Model
public protocol AccountWrapper {
    
    var account_id: Int64 { get }
    
    /// Name of the account.
    var name: String? { get set }
    
    /// Recipes which favorited by the account.
    var favoriteRecipes: NSSet? { get }
    
    /// Add a new recipe to the account's favorite recipes list.
    /// - Parameter value: Recipe which favorite by the account.
    func addToFavoriteRecipes(_ value: RecipeWrapper)
    
    /// Unfavorite a recipe from the favorite list of the account.
    /// - Parameter value: Recipe unfavorited by the account.
    func removeFromFavoriteRecipes(_ value: RecipeWrapper)
    
    /// Favorite a set of recipes the the account's favorite recipe list.
    /// - Parameter values: A set of favorite account.
    func addToFavoriteRecipes(_ values: NSSet)
    
    /// Unfavorite a set of recipe from the favorite list of the account.
    /// - Parameter values: A set of recipes.
    func removeFromFavoriteRecipes(_ values: NSSet)
}

extension AccountModel: AccountWrapper {
    
    /// Add a recipe to the account.
    /// - Parameter value: The recipe that favorited by the account.
    public func addToFavoriteRecipes(_ value: RecipeWrapper) {
        if let recipe = value as? RecipeModel {
            addToFavoriteRecipes(recipe)
        }
    }
    
    /// Remove a recipe from an account.
    /// - Parameter value: The recipe that unfavorited by the account.
    public func removeFromFavoriteRecipes(_ value: RecipeWrapper) {
        if let recipe = value as? RecipeModel {
            removeFromFavoriteRecipes(recipe)
        }
    }
}
