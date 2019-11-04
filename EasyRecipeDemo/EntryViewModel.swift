//
//  EntryViewModel.swift
//  EasyRecipeDemo
//
//  Created by Hsiao, Wayne on 2019/11/2.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHUIComponents

class EntryViewModel {
    weak var coordinator: Coordinator?
    
    var title = "Demo"
    
    var backgroundColor = UIColor.systemBackground
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowAt(section: Int) -> Int {
        return EntryType.count
    }
    
    func attributedTextBy(indexPath: IndexPath) -> NSAttributedString {
        let entryType = EntryType(rawValue: indexPath.row)
        switch entryType {
        case .info:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone.current
            return attributedTitle("Date", content: "\(dateFormatter.string(from: Date()))", highlight: false)
        case .loginViewDemo:
            return attributedTitle("Demo1", content: "Login View Demo", highlight: false)
        case .easyRecipeDemo:
            return attributedTitle("Demo2", content: "Easy Recipe Demo", highlight: true)
        default:
            return attributedTitle("", content: "", highlight: false)
        }
    }
    
    func attributedTitle(_ title: String, content: String, highlight: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        let title = NSAttributedString(string: "\(title):", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
        let backgroundColor = highlight == true ? UIColor.systemYellow : UIColor.systemBackground
        let content = NSAttributedString(string: " \(content)", attributes: [.font: UIFont.systemFont(ofSize: 17),
                                                                             .backgroundColor: backgroundColor
        ])
        attributedString.append(title)
        attributedString.append(content)
        return attributedString
    }
    
    func didSelectAt(indexPath: IndexPath) {
        guard let entryType = EntryType(rawValue: indexPath.row),
            let mainCoordinator = coordinator as? MainCoordinator else {
                return
        }
        mainCoordinator.navigateToNextPage(entryType)
    }
}
