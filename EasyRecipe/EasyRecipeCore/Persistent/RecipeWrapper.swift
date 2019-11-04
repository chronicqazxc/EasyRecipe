//
//  RecipeWrapper.swift
//  CoreDataDemo
//
//  Created by Hsiao, Wayne on 2019/10/3.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

/// As a abstract interface which intended to hide the concrete Persistent Model
public protocol RecipeWrapper {
    
    /// Name of the recipe.
    var name: String? { get set }
    
    /// Accounts which favorited the recipe.
    var favoritedBy: NSSet? { get set }
    
    /// Add the recipe to the favorite recipe list ot a account.
    /// - Parameter value: The account which favorite the recipe.
    func addToFavoritedBy(_ value: AccountWrapper)
    
    /// Remove the recipe from the favorite list of a account.
    /// - Parameter value: The account which unfavorited the recipe.
    func removeFromFavoritedBy(_ value: AccountWrapper)
    
    /// Add the recipe to bunch of accounts.
    /// - Parameter values: The set of accounts which favorite the recipe.
    func addToFavoritedBy(_ values: NSSet)
    
    /// Remove the recipe from bunch of accounts.
    /// - Parameter values: The set of accounts which unfavorite the recipe.
    func removeFromFavoritedBy(_ values: NSSet)
}

extension RecipeModel: RecipeWrapper {
    
    /// Add the recipe to an account.
    /// - Parameter value: The account which favorited the recipe.
    public func addToFavoritedBy(_ value: AccountWrapper) {
        if let account = value as? AccountModel {
            addToFavoritedBy(account)
        }
    }
    
    /// Remove the recipe from an account.
    /// - Parameter value: The account which unfavorited the recipe.
    public func removeFromFavoritedBy(_ value: AccountWrapper) {
        if let account = value as? AccountModel {
            removeFromFavoritedBy(account)
        }
    }
}
