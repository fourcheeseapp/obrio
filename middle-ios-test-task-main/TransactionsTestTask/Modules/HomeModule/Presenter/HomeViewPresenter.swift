//
//  HomePresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation

protocol HomeViewPresenterProtocol {
    func onViewDidLoad()
    func onTapTransactions()
    func onTapAdd()
}

final class HomeViewPresenter {
    private weak var view: HomeView?
    private let router: HomeViewRouter
    private var sections: [HomeViewModel.Section] = []
    
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
    func onTapTransactions() {
        // TODO: -
    }
    
    func onTapAdd() {
        // TODO: -
    }
    
    func onViewDidLoad() {
        configureHeader()
        prepareSections()
    }
}

// MARK: - Privates
private extension HomeViewPresenter {
    func prepareSections() {
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .electronics
            ))]
        ))
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .groceries
            ))]
        ))
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .other
            ))]
        ))
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .refill
            ))]
        ))
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .restaurant
            ))]
        ))
        sections.append(HomeViewModel.Section(
            type: .transactions(UUID().uuidString),
            items: [HomeViewModel.SectionItem.transaction(TransactionModel(
                time: "20:34",
                amount: 200.0,
                category: .taxi
            ))]
        ))
        view?.reloadData(with: sections)
    }
    
    func configureHeader() {
        let headerViewModel = HomeHeaderViewModel(
            coinName: Constants.coinName,
            balance: "73.945",
            priceTitle: Constants.priceTitle,
            currentPrice: Constants.dollarSign + "129,00",
            transactionTitle: Constants.transactionTitle
        )
        view?.configureHeader(with: headerViewModel)
    }
    
    // MARK: - Constants
    enum Constants {
        static let dollarSign: String = "$"
        static let btcSign: String = "btc"
        static let transactionTitle: String = "Add transaction"
        static let coinName: String = "Bitcoin/BTC"
        static let priceTitle: String = "BTC/USDT"
    }
}

