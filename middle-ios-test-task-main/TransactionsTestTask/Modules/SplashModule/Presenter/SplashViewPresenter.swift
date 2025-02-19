//
//  SplashViewPresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation

protocol SplashViewPresenterProtocol: AnyObject {
    func onViewDidLoad()
}

final class SplashViewPresenter {
    private weak var view: SplashView?
    private let router: SplashViewRouter
    
    // MARK: - init 
    init(
        view: SplashView,
        router: SplashViewRouter
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - SplashViewPresenterProtocol
extension SplashViewPresenter: SplashViewPresenterProtocol {
    func onViewDidLoad() {
        view?.setupTitle(Consants.title)
        onMainQueue(after: .now() + 4) { [weak self] in
            self?.router.replaceRootModule(with: HomeModule())
        }
    }
}

// MARK: - Consants
private extension SplashViewPresenter {
    enum Consants {
        static let title = "Nice to HODL you"
    }
}

