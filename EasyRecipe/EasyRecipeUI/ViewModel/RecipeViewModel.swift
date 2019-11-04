//
//  RecipeViewModel.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import ProfileCore
import EasyRecipeCore
import WHUIComponents

protocol RecipeViewModel {
    var coordinator: Coordinator? { get set }
}

extension RecipeViewModel {
    func isFavorited(_ recipe: Recipe) -> Bool {
        
        guard let profile = Profile.current,
            let account = PersistentHelper.persistentProfile(accountName(profile)),
            let recipe = PersistentHelper.persistentRecipe(recipe.id) else {
                return false
        }
        return recipe.favoritedBy?.contains(account) == true
    }
    
    func accountName(_ profile: Profile) -> String {
        return profile.firstName + profile.lastName
    }
}
