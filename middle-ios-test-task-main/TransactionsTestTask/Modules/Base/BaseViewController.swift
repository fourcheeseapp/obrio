//
//  BaseViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private
private extension BaseViewController {
    func setupUI() {
        view.backgroundColor = Colors.mainBackground
    }
}
