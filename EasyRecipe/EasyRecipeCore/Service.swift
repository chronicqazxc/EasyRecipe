//
//  Service.swift
//  EasyRecipeCore
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHCoreServices


/// Any services which able to get recipes should adopt this protocol.
public protocol RecipeService {
    func getRecipes(completeHandler: NetworkCompletionHandler)
}

extension Service: RecipeService {
    public func getRecipes(completeHandler: NetworkCompletionHandler) {
        // TODO: Real service
        fatalError("To be implemented with real service.")
    }
}

