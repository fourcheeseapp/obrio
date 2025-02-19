//
//  SplashScreenModule.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

final class SplashScreenModule {
    private let view: SplashScreenViewController
    
    init() {
        view = SplashScreenViewController()
        let router = SplashScreenRouter(viewController: view)
        let presenter = SplashScreenPresenter(
            view: view,
            router: router
        )
        view.presenter = presenter
    }
}

extension SplashScreenModule: BaseModule {
    func viewController() -> UIViewController {
        return view
    }
}

