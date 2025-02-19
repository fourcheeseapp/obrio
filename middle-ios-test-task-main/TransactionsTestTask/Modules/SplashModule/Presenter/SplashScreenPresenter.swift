//
//  SplashScreenPresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation

protocol SplashScreenPresenterProtocol: AnyObject {
    func onViewDidLoad()
}

final class SplashScreenPresenter {
    private weak var view: SplashScreenViewController?
    private let router: SplashScreenRouter
    
    // MARK: - init 
    init(
        view: SplashScreenViewController,
        router: SplashScreenRouter
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - SplashScreenPresenterProtocol
extension SplashScreenPresenter: SplashScreenPresenterProtocol {
    func onViewDidLoad() {
        view?.setupTitle(Consants.title)
        onMainQueue(after: .now() + 3) { [weak self] in
            guard let self else { return }
//            self.router.replaceRootModule(with: HomeModule())
        }
    }
}

private extension SplashScreenPresenter {
    enum Consants {
        static let dellay = 3
        static let title = "Nice to HODL you"
    }
}

