//
//  AppNavigationController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

final class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private 
private extension BaseNavigationController {
    func setupUI() {
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .clear
        navigationBar.backItem?.title = ""
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
