//
//  ViewController.swift
//  EasyRecipeDemo
//
//  Created by Hsiao, Wayne on 2019/10/4.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import WHUIComponents

class EntryViewController: UITableViewController, CoordinatorViewController {
    
    var coordinateDelegate: CoordinatorViewContollerDelegate?
    var viewModel: EntryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowAt(section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.attributedText = viewModel.attributedTextBy(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectAt(indexPath: indexPath)
    }
}
