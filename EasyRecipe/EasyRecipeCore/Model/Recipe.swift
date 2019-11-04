//
//  Recipe.swift
//  EasyRecipeCore
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

public struct Recipe: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case headline
        case description
        case difficulty
        case prepTime
        case link
        case imageLink
        case nutrition
        case ingredients
        case averageRating
        case ratingsCount
    }
    
    public let id: String
    public let name: String
    public let headline: String
    public let description: String
    public let difficulty: Int
    public let prepTime: String
    public let link: String
    public let imageLink: String
    public let nutrition: [Nutrition]
    public let ingredients: [Ingredient]
    public let averageRating: Int
    public let ratingsCount: Int
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(headline, forKey: .headline)
        try container.encode(description, forKey: .description)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(prepTime, forKey: .prepTime)
        try container.encode(link, forKey: .link)
        try container.encode(imageLink, forKey: .imageLink)
        try container.encode(nutrition, forKey: .nutrition)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(averageRating, forKey: .averageRating)
        try container.encode(ratingsCount, forKey: .ratingsCount)
    }
}
