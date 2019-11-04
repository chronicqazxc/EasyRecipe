//
//  RecipeDetailCoordinator.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHUIComponents
import EasyRecipeCore

/// Coordinator that in charge of present the RecipeDetailViewController and the navigation logic.
public class RecipeDetailCoordinator: Coordinator {
    
    
    public var coordinators = [Coordinator]()
    public var parameters: [AnyHashable : Any]?
    weak var navigationController: UINavigationController!
    public var viewModel: RecipeDetailViewModel?
    public var delegate: CoordinatorDelegate?
    
    public var viewController: UIViewController?
    
    public required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        guard let viewModel = viewModel else {
            return
        }
        let recipeDetailViewController = RecipeDetailViewController.controller(viewModel: viewModel)
        recipeDetailViewController.coordinateDelegate = self
        navigationController.pushViewController(recipeDetailViewController, animated: true)
    }
}

extension RecipeDetailCoordinator: CoordinatorViewContollerDelegate {
    public func navigateToNextPage() {
        
    }
    
    public func naviageBackToPreviousPage() {
        
    }
}
