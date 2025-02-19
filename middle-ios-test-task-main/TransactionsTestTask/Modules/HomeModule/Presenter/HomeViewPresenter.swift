//
//  HomePresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation

protocol HomeViewPresenterProtocol {
    func onViewDidLoad()
}

final class HomeViewPresenter {
    private weak var view: HomeView?
    private let router: HomeViewRouter
    
    init(
        view: HomeView,
        router: HomeViewRouter
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - HomePresenterProtocol
extension HomeViewPresenter: HomeViewPresenterProtocol {
    func onViewDidLoad() {
        
    }
}
