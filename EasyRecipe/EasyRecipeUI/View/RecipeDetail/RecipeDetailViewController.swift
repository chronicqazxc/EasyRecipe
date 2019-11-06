//
//  RecipeDetailViewController.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import EasyRecipeCore
import WHUIComponents

/// Represent the information about the Recipe object, recipe image, title, headline, description, ingredients, nutrition info.
/// Able to favorite/unfavorite as well as the rating.
public class RecipeDetailViewController: UITableViewController, CoordinatorViewController {
    public var coordinateDelegate: CoordinatorViewContollerDelegate?
    fileprivate var viewModel: RecipeDetailViewModel!

    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        title = viewModel.title
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        RecipeDetailSection.registerCells(forTableView: tableView)

        viewModel.recipeImageDownloadComplete = { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
        viewModel.ingredientImageDownloadComplete = { [weak self] (rows) in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        guard indexPath.row < viewModel.items.count else {
            let cell = defaultCell
            return cell
        }

        let section = viewModel.recipeDetailSectionBy(indexPath: indexPath)
        guard let detailCell = section.cellForTableView(tableView, atIndexPath: indexPath) else {
            return defaultCell
        }
        detailCell.configCellWith(viewModel: viewModel,
                                  atIndexPath: indexPath,
                                  tableViewController: self)
        return detailCell
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

extension RecipeDetailViewController {
    /// Designated initializer.
    /// - Parameter recipe: Recipe object to be present.
    public static func controller(viewModel: RecipeDetailViewModel) -> RecipeDetailViewController {
        let recipeDetailViewController = RecipeDetailViewController(nibName: "RecipeDetailViewController",
                                           bundle: Resource.bundle)
        recipeDetailViewController.viewModel = viewModel
        return recipeDetailViewController
    }
}

extension RecipeDetailViewController: RecipeDetailImageCellDelegate, RecipeDetailRatingCellDelegate {
    func starButtonTapped(_ cell: RecipeDetailRatingCell) {
        viewModel.ratingButtonTapped(rating: cell.rating)
        tableView.reloadData()
    }
    
    func favoriteButtonTapped(cell: RecipeDetailImageCell) {
        viewModel.favoriteButtonTapped { [weak self] (updateSuccess) in
            if updateSuccess == true {
                self?.tableView.reloadData()
            }
        }
    }
}
