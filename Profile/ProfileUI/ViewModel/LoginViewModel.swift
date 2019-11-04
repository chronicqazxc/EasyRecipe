//
//  LoginViewModel.swift
//  ProfileUI
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import ProfileCore
import WHCoreServices
import WHUIComponents

public enum Placeholder: String {
    case email
    case password
}

public enum LoginViewModelError: Error {
    case unknowError
    case invalidEmail
    case passwordMinimum
}

enum RegExp {
    static let email = #"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"#
    static let password = #"^.{8,}$"#
}

public typealias LoginViewModelCallback = (Profile?, Error?)->Void

public class LoginViewModel: NSObject {
    enum UIComponents {
        case emailTextField
        case passwordTextField
        case submiteButton
        case emptyCell
        case titleCell
        case dismissCell
    }
    
    let components: [UIComponents] = [
        .dismissCell,
        .titleCell,
        .emailTextField,
        .passwordTextField,
        .emptyCell,
        .emptyCell,
        .emptyCell,
        .submiteButton
    ]
    
    var callback: LoginViewModelCallback?
    fileprivate var profileService: ProfileService!
    fileprivate(set) var email: String = ""
    fileprivate(set) var password: String = ""
    weak var coordinator: Coordinator?
    
    lazy public var authenticationService: AuthenticationService = {
        let service = AuthenticationService(service: profileService)
        return service
    }()
    
    public init(profileService: ProfileService = Service.shared,
                callback: LoginViewModelCallback? = nil) {
        self.callback = callback
        self.profileService = profileService
    }
    
    public func guestLogin() {
        authenticationService.guestLogin(email: email, password: password) { [weak self] (profile, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard email.range(of: RegExp.email,
                              options: .regularExpression) != nil else {
                                strongSelf.callback?(nil, LoginViewModelError.invalidEmail)
                                return
            }
            
            guard password.range(of: RegExp.password,
                              options: .regularExpression) != nil else {
                                strongSelf.callback?(nil, LoginViewModelError.passwordMinimum)
                                return
            }
            
            if let profile = profile {
                strongSelf.callback?(profile, nil)
            } else if let error = error {
                strongSelf.callback?(nil, error)
            } else {
                strongSelf.callback?(nil, LoginViewModelError.unknowError)
            }
        }
    }
    
    func loginSuccess() {
        coordinator?.navigateToNextPage()
    }
    
    func loginFailed() {
        
    }
}

extension LoginViewModel {
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return components.count
    }
    
    func componentsBy(indexPath: IndexPath) -> UIComponents? {
        guard indexPath.row < components.count else {
            return nil
        }
        return components[indexPath.row]
    }
    
    func placeholderBy(component: UIComponents) -> String {
        switch component {
        case .emailTextField:
            return Placeholder.email.rawValue
        case .passwordTextField:
            return Placeholder.password.rawValue
        default:
            return ""
        }
    }
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
}
