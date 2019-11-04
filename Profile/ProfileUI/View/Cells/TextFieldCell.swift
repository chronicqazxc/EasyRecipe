//
//  TextFieldCell.swift
//  ProfileUI
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: SecureTextField!
    @IBOutlet weak var displayPasswordButton: UIButton! {
        didSet {
            displayPasswordButton.isHidden = true
            displayPasswordButton.setTitle("🙈", for: .normal)
        }
    }
    
    var isSecureTextEntry: Bool = false {
        didSet {
            displayPasswordButton.isHidden = !isSecureTextEntry
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func displayPasswordTapped(_ sender: Any) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        if textField.isSecureTextEntry == true {
            displayPasswordButton.setTitle("🙈", for: .normal)
        } else {
            displayPasswordButton.setTitle("🐵", for: .normal)
        }
    }
    
}
