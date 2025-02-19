//
//  BaseModule.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

protocol BaseModule {
    func viewController() -> UIViewController
}

protocol BaseViewModule {
    associatedtype ViewType: UIView
    func customView() -> ViewType
}
