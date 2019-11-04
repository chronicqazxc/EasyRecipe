//
//  SecureTextField.swift
//  ProfileUI
//
//  Created by Hsiao, Wayne on 2019/10/7.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit


/// A security test filed with prevent user to copy or paste contents of this text field.
class SecureTextField: UITextField {
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
