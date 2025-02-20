//
//  HomePresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation
import Combine

protocol HomeViewPresenterProtocol {
    func onViewDidLoad()
    func onTapTransactions()
    func onTapAdd()
    func didRefillWallet(with value: Double)
}

final class HomeViewPresenter {
    private weak var view: HomeView?
    private let router: HomeViewRouter
    private var sections: [HomeViewModel.Section] = []
    private let rateService = ServicesAssembler.bitcoinRateService()
    private let coreDataService = ServicesAssembler.coreDataService()
    private var currentBalance: Double {
        get {
            coreDataService.getValueFromNumericField(forKey: .balance)
        }
    }
    private var currentPrice: Double {
        get {
            coreDataService.getValueFromNumericField(forKey: .currentPrice)
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - init
    init(
        view: HomeView,
        router: HomeViewRouter,
        coreDataService: CoreDataService
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - HomePresenterProtocol
extension HomeViewPresenter: HomeViewPresenterProtocol {
    func didRefillWallet(with value: Double) {
        let updatedBalance = currentBalance + value
        coreDataService.updateNumericField(with: updatedBalance, forKey: .balance)
        view?.updateBalance(updatedBalance)
    }
    
    func onTapTransactions() {
        // TODO: -
    }
    
    func onTapAdd() {
        view?.showInputView()
    }
    
    func onViewDidLoad() {
        configureHeader()
        prepareSections()
        startMonitoringPrice()
    }
}

// MARK: - Privates
private extension HomeViewPresenter {
    func startMonitoringPrice() {
        rateService.startMonitoringPrice()
        rateService.ratePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let rate):
                    self.view?.updatePrice(Constants.dollarSign + String(format: "%.3f", rate))
                case .failure(let error):
                    self.view?.updatePrice(Constants.dollarSign + String(format: "%.3f", currentPrice))
                    self.view?.showError(with: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
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
            balance: currentBalance,
            priceTitle: Constants.priceTitle,
            currentPrice: Constants.dollarSign + Constants.emptyState,
            transactionTitle: Constants.transactionTitle
        )
        view?.configureHeader(with: headerViewModel)
    }
    
    // MARK: - Constants
    enum Constants {
        static let emptyState: String = "-"
        static let dollarSign: String = "$"
        static let btcSign: String = "btc"
        static let transactionTitle: String = "Add transaction"
        static let coinName: String = "Bitcoin/BTC"
        static let priceTitle: String = "BTC/USDT"
    }
}

