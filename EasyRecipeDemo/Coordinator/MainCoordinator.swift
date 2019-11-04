//
//  MainCoordinator.swift
//  EasyRecipeDemo
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import ProfileUI
import ProfileCore
import EasyRecipeUI
import WHUIComponents

class MainCoordinator: Coordinator {
    
    var delegate: CoordinatorDelegate?
    var coordinators = [Coordinator]()
    var parameters: [AnyHashable : Any]?
    weak private(set) var viewController: UIViewController?
    weak var navigationController: UINavigationController!
    let service = MockService.shared
    
    var loginViewModel: LoginViewModel {
        return LoginViewModel(profileService: service)
    }
    
    var recipeListViewModel: RecipeListViewModel {
        return RecipeListViewModel(service: service)
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = EntryViewModel()
        viewModel.coordinator = self
        
        let viewController = EntryViewController(style: .plain)
        viewController.viewModel = viewModel
        viewController.tableView.dataSource = viewController
        viewController.tableView.delegate = viewController
        viewController.tableView.separatorStyle = .none

        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.viewControllers = [viewController]
        
        self.viewController = viewController
    }
    
}

extension MainCoordinator: CoordinatorDelegate {
    func finish() {
        coordinators.removeLast()
    }
    
    func navigateToNextPage() {
        navigateToNextPage(.easyRecipeDemo)
    }
    
    func navigateToNextPage(_ entryType: EntryType) {
        switch entryType {
        case .loginViewDemo:
            let viewModel = LoginViewModel(profileService: MockService.shared)
            let authenticationService = viewModel.authenticationService
            
            let loginCoordinator = LoginViewControllerCoordinator(navigationController: navigationController)
            loginCoordinator.loginViewModel = viewModel
            loginCoordinator.start {
                guard let profile = Profile.current else {
                    self.viewController?.dismiss(animated: true, completion: nil)
                    return
                }
                let alertController = self.alertController(title: "LoggedIn",
                                                           message: "\(profile.firstName) \(profile.lastName) \n \(profile.email)", actionTitle: "ok") { (action) in
                                                            authenticationService.guestLogout()
                }
                self.viewController?.present(alertController, animated: true, completion: nil)
            }
            coordinators.append(loginCoordinator)
            
        case .easyRecipeDemo:
            let recipeListCoordinator = RecipeListCoordinator(navigationController: navigationController!)
            recipeListCoordinator.recipeListViewModel = recipeListViewModel
            recipeListCoordinator.loginViewModel = loginViewModel
            recipeListCoordinator.delegate = self
            recipeListCoordinator.start()
            coordinators.append(recipeListCoordinator)
        default:
            break
        }
    }
    
    func alertController(title: String, message: String, actionTitle: String, action: ((UIAlertAction)->Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        alertController.addAction(action)
        return alertController
    }
    
    func naviageBackToPreviousPage(_ entryType: EntryType) {

    }
    
    func naviageBackToPreviousPage() {
        
    }
}
