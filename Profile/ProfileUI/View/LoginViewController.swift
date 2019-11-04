//
//  LoginViewController.swift
//  ProfileUI
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import ProfileCore

public typealias LoginViewCompleteHandler = (Profile?, Error?) -> Void
public typealias LoginViewDismissHandler = (Profile?) -> Void

enum Constant {
    static let defaultCell = "DefaultCell"
    static let textFieldCell = "TextFieldCell"
    static let submitCell = "SubmitCell"
    static let titleCell = "TitleCell"
    static let dismissCell = "DismissCell"
    static let title = "Login"
}

/// LoginViewController enable user login by email and password with any custom service api call.
public class LoginViewController: UITableViewController {
    
    fileprivate var loginViewCompleteHandler: LoginViewCompleteHandler!
    fileprivate var loginViewDismissHandler: LoginViewDismissHandler?
    fileprivate var viewModel: LoginViewModel!
    static let bundle = Bundle(identifier: "com.wayne.hsiao.ProfileUI")
        
    private init() {
        super.init(coder: NSCoder())!
        fatalError("Please use designated initializer.")
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constant.defaultCell)
        tableView.register(UINib(nibName: Constant.textFieldCell,
                                 bundle: LoginViewController.bundle),
                           forCellReuseIdentifier: Constant.textFieldCell)
        tableView.register(UINib(nibName: Constant.submitCell,
                                 bundle: LoginViewController.bundle),
                           forCellReuseIdentifier: Constant.submitCell)
        tableView.register(UINib(nibName: Constant.titleCell,
                                 bundle: LoginViewController.bundle),
                           forCellReuseIdentifier: Constant.titleCell)
        tableView.register(UINib(nibName: Constant.dismissCell,
                                 bundle: LoginViewController.bundle),
                           forCellReuseIdentifier: Constant.dismissCell)
        
        viewModel.callback = { [weak self] (profile, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let profile = profile {
                strongSelf.dismiss(animated: true, completion: {
                    strongSelf.loginViewCompleteHandler(profile, nil)
                })
            } else if let error = error {
                let alertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                alertController.addAction(action)
                switch error {
                case LoginViewModelError.invalidEmail:
                    alertController.message = "Invalid email format."
                    strongSelf.present(alertController, animated: true, completion: nil)
                case LoginViewModelError.passwordMinimum:
                    alertController.message = "Password should be at least 8 characters."
                    strongSelf.present(alertController, animated: true, completion: nil)
                default:
                    alertController.message = "\(error.localizedDescription)"
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let component = viewModel.componentsBy(indexPath: indexPath)
        switch component {
        case .emailTextField:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.textFieldCell,
                                                 for: indexPath)
            guard let textFieldCell = cell as? TextFieldCell else {
                return cell
            }
            textFieldCell.textField.textContentType = .emailAddress
            textFieldCell.textField.placeholder = viewModel.placeholderBy(component: .emailTextField)
            textFieldCell.textField.autocorrectionType = .no
            textFieldCell.textField.delegate = self
        case .passwordTextField:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.textFieldCell,
                                                 for: indexPath)
            guard let textFieldCell = cell as? TextFieldCell else {
                return cell
            }
            textFieldCell.textField.textContentType = .password
            textFieldCell.isSecureTextEntry = true
            textFieldCell.textField.placeholder = viewModel.placeholderBy(component: .passwordTextField)
            textFieldCell.textField.autocorrectionType = .no
            textFieldCell.textField.delegate = self
        case .submiteButton:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.submitCell,
                                                 for: indexPath)
            guard let submitCell = cell as? SubmitCell else {
                return cell
            }
            submitCell.submitButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        case .titleCell:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.titleCell,
                                                 for: indexPath)
            guard let titleCell = cell as? TitleCell else {
                return cell
            }
            titleCell.title = Constant.title
        case .dismissCell:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.dismissCell,
                                                 for: indexPath)
            guard let dismissCell = cell as? DismissCell else {
                return cell
            }
            dismissCell.dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: Constant.defaultCell,
                                                 for: indexPath)
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc func login() {
        viewModel.guestLogin()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginViewDismissHandler?(nil)
    }
}

extension LoginViewController {
    
    /// Convenience method to return a LoginViewController with necessary parameters.
    /// - Parameter viewModel: LoginViewModel
    /// - Parameter completeHandler: Will called once login request complete.
    /// - Parameter dismissHandler: Will called once the login view controller has dismissed.
    public static func controllerWith(viewModel: LoginViewModel,
                                      completeHandler: @escaping LoginViewCompleteHandler,
                                      dismissHandler: LoginViewDismissHandler? = nil) -> LoginViewController {
        
        let loginViewController = LoginViewController(nibName: "LoginViewController",
                                                      bundle: LoginViewController.bundle)
        loginViewController.viewModel = viewModel
        loginViewController.loginViewCompleteHandler = completeHandler
        loginViewController.loginViewDismissHandler = dismissHandler
        return loginViewController
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        guard let text = textField.text,
            let range = Range(range, in: text) else {
            return false
        }
        let updatedText = text.replacingCharacters(in: range, with: string)
        if textField.placeholder == viewModel.placeholderBy(component: .emailTextField) {
            viewModel.updateEmail(updatedText)
        } else if textField.placeholder == viewModel.placeholderBy(component: .passwordTextField) {
            viewModel.updatePassword(updatedText)
        }
        return true
    }
}
