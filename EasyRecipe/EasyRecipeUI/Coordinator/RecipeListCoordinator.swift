//
//  Coordinator.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/6.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHUIComponents
import EasyRecipeCore
import ProfileCore
import ProfileUI

/// Coordinator that in charge of present the RecipeListViewController and the navigation logic.
public class RecipeListCoordinator: Coordinator {
    enum NavigateState {
        case login
        case recipe
        case none
    }
    private var navigateState: NavigateState = .none
    public var delegate: CoordinatorDelegate?
    public var coordinators = [Coordinator]()
    public var parameters: [AnyHashable : Any]?
    weak private(set) public var viewController: UIViewController?
    weak private(set) var navigationController: UINavigationController!
    lazy var recipeNavigationController = UINavigationController()
    public var loginViewModel: LoginViewModel?
    public var recipeListViewModel: RecipeListViewModel?
    
    required public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let recipeListViewModel = self.recipeListViewModel ?? RecipeListViewModel()
        recipeListViewModel.coordinator = self
        guard let easyRecipeListViewController = RecipeListViewController.controller(viewModel: recipeListViewModel) else {
            return
        }
        viewController = easyRecipeListViewController
        recipeNavigationController.navigationBar.prefersLargeTitles = true
        recipeNavigationController.viewControllers = [easyRecipeListViewController]
        navigationController.present(recipeNavigationController, animated: true, completion: nil)
    }
}

extension RecipeListCoordinator: CoordinatorDelegate {
    public func finish() {
        switch navigateState {
        case .login:
            if Profile.isLoggedIn == true {
                (viewController as? RecipeListViewController)?.viewModel.getRecipes()
            } else {
                naviageBackToPreviousPage()
            }
        case .recipe:
            break
        case .none:
            break
        }
        coordinators.removeLast()
    }

    public func navigateToNextPage() {
        
        if Profile.isLoggedIn == true {
            navigateState = .recipe
            let recipeDetailCoordinator = RecipeDetailCoordinator(navigationController: recipeNavigationController)
            guard let recipeListViewController = viewController as? RecipeListViewController,
                let recipe = recipeListViewController.viewModel.selectedRecipe else {
                    return
            }
            recipeDetailCoordinator.viewModel = RecipeDetailViewModel(recipe: recipe)
            recipeDetailCoordinator.delegate = self
            recipeDetailCoordinator.start()
            coordinators.append(recipeDetailCoordinator)
        } else {
            navigateState = .login
            let loginCoordinator = LoginViewControllerCoordinator(navigationController: recipeNavigationController)
            loginCoordinator.loginViewModel = loginViewModel ?? LoginViewModel()
            loginCoordinator.delegate = self
            loginCoordinator.start()
            coordinators.append(loginCoordinator)
        }
    }
    
    /// Present a LoginViewController.
    /// - Parameter dismissHandler: Will be called after the LoginViewController dismissed.
    func  navigateToLoginViewController(dismissHandler: @escaping ()->Void) {
        let loginCoordinator = LoginViewControllerCoordinator(navigationController: recipeNavigationController)
        loginCoordinator.loginViewModel = loginViewModel ?? LoginViewModel()
        loginCoordinator.start()
        coordinators.append(loginCoordinator)
    }
    
    func isLoggedIn() -> Bool {
        return Profile.current != nil
    }
    
    func alertController(title: String, message: String, actionTitle: String, action: ((UIAlertAction)->Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        alertController.addAction(action)
        return alertController
    }
    
    public func naviageBackToPreviousPage() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
