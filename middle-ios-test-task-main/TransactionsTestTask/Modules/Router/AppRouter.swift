//
//  AppRouter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

final class AppRouter: BaseRouter {
    private let window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
 
    func start() {
        let module = SplashScreenModule()
        window.rootViewController = module.viewController()
        window.makeKeyAndVisible()
    }
}
