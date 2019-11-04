//
//  DownloadableIcon.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/7.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import EasyRecipeCore

protocol DownloadableIcon {
    var imageURL: String { get }
}

extension Recipe: DownloadableIcon {
    var imageURL: String {
        return imageLink
    }
}

extension Ingredient: DownloadableIcon {
    var imageURL: String {
        return imageLink
    }
}
