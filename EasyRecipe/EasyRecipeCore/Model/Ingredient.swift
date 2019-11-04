//
//  Ingredient.swift
//  EasyRecipeCore
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

public struct Ingredient: Codable {
    public let id: String
    public let type: String
    public let name: String
    public let imageLink: String
}
