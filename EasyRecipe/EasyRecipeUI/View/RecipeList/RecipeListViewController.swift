//
//  RecipeListViewController.swift
//  ProfileUI
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import ProfileUI
import ProfileCore
import EasyRecipeCore
import MyService
import WHUIComponents

/// Represent a list recipes which include the recipe image, name, headline.
/// Able to favorite/unfavorite as well as the rating.
public class RecipeListViewController: UITableViewController {
    
    enum Constant {
        static let defaultCell = "DefaultCell"
        static let recipeListCell = "RecipeListCell"
    }

//    var pendingOperations = PendingIconDownloaderOperations()

    fileprivate(set) var viewModel: RecipeListViewModel!
        
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getRecipeCallback = { [weak self] (data, error) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        viewModel.getImageCallback = { [weak self] (rows) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadRows(at: rows, with: .fade)
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.defaultCell)
        let nib = UINib(nibName: "RecipeListCell", bundle: Resource.bundle)
        tableView.register(nib, forCellReuseIdentifier: Constant.recipeListCell)
        title = "Recipe List"
        view.backgroundColor = UIColor.systemBackground
        viewModel.loginOrGetRecipes()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = RecipeListCell.height
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.items.count > indexPath.row,
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.recipeListCell, for: indexPath) as? RecipeListCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.defaultCell, for: indexPath)
            return cell
        }
        cell.tableViewController(self, cellForRowAt: indexPath, viewModel: viewModel)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(didSelectRowAt: indexPath)
    }
    
    override public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.scrollViewWillBeginDragging()
    }
    
    override public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnScreenCells()
            viewModel.scrollViewDidEndDragging()
        }
    }
    
    override public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnScreenCells()
        viewModel.scrollViewDidEndDecelerating()
    }
    
    func loadImagesForOnScreenCells() {
        guard let pathes = tableView.indexPathsForVisibleRows else {
            return
        }
        viewModel.loadImagesForOnScreenCells(pathes: pathes)
    }
}

extension RecipeListViewController {
    
    /// Convenience function to return a RecipeListViewController with necessary parameter.
    /// - Parameter viewModel: RecipeListViewModel
    public static func controller(viewModel: RecipeListViewModel) -> RecipeListViewController? {
        let recipeListViewController = RecipeListViewController(nibName: "RecipeListViewController",
                                                                  bundle: Resource.bundle)
        recipeListViewController.viewModel = viewModel
        return recipeListViewController
    }
}

extension RecipeListViewController: RecipeListCellDelegate {
    func favoriteButtonTapped(_ cell: RecipeListCell, indexPath: IndexPath?) {
        viewModel.favoriteButtonTapped(indexPath: indexPath) { (updateSuccess) in
            if updateSuccess == true, let index = indexPath {
                cell.isFavorite = viewModel.recipeIsFavoritedBy(indexPath: index)
            }
        }
    }
    
    func ratingButtonTapped(_ cell: RecipeListCell, indexPath: IndexPath?) {
        viewModel.ratingButtonTapped(cell.rating, indexPath: indexPath)
        
    }
}
