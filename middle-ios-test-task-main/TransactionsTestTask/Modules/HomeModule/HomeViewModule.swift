//
//  HomeModule.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

final class HomeModule {
    private let view: HomeViewController
    
    init() {
        view = HomeViewController()
        let router = HomeViewRouter(viewController: view)
        let presenter = HomeViewPresenter(
            view: view,
            router: router
        )
        view.presenter = presenter
    }
}

extension HomeModule: BaseModule {
    func viewController() -> UIViewController {
        return view
    }
}
