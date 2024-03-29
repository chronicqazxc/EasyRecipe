//
//  LoginViewControllerCoordinator.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/9.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import WHUIComponents
import ProfileCore

public class LoginViewControllerCoordinator: Coordinator {
    public var delegate: CoordinatorDelegate?
    
    public var coordinators = [Coordinator]()
    
    public func navigateToNextPage() {
        
    }
    
    public func naviageBackToPreviousPage() {
        
    }
    
    public var parameters: [AnyHashable : Any]?
    public var loginViewModel: LoginViewModel?
    
    public var viewController: UIViewController?
    var navigationController: UINavigationController!
    
    public required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let loginViewModel = self.loginViewModel ?? LoginViewModel()
        let loginViewController = LoginViewController.controllerWith(viewModel: loginViewModel, completeHandler: { (_, _) in
            
        }, dismissHandler: { [weak self] (_) in
            self?.delegate?.finish()
        })
        navigationController.present(loginViewController, animated: true, completion: nil)
    }
}
