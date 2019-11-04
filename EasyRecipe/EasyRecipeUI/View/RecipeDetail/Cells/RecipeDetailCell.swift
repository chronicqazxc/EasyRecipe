//
//  RecipeDetailCell.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/8.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

protocol RecipeDetailCell: UITableViewCell {
    static var nibName: String { get }
    func configCellWith(viewModel: RecipeDetailViewModel,
                        atIndexPath indexPath: IndexPath,
                        tableViewController: UITableViewController)
}
