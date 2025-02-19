//
//  SplashViewModule.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

final class SplashViewModule {
    private let view: SplashViewController
    
    init() {
        view = SplashViewController()
        let router = SplashViewRouter(viewController: view)
        let presenter = SplashViewPresenter(
            view: view,
            router: router
        )
        view.presenter = presenter
    }
}

extension SplashViewModule: BaseModule {
    func viewController() -> UIViewController {
        return view
    }
}
