//
//  Nutrition.swift
//  EasyRecipeCore
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

public struct Nutrition: Codable {
    public let id: String?
    public let name: String
    public let amount: Int
    public let unit: String
}
