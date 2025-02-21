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
    func onViewWillAppear()
    func onViewDidDissapear()
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
        router: HomeViewRouter
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - HomePresenterProtocol
extension HomeViewPresenter: HomeViewPresenterProtocol {
    func onViewDidLoad() {
        configureHeader()
    }
    
    func onViewWillAppear() {
        startMonitoringPrice()
        prepareSections()
        view?.updateBalance(currentBalance)
    }
    
    func onViewDidDissapear() {
        rateService.stopMonitoringPrice()
    }
    
    func didRefillWallet(with value: Double) {
        let updatedBalance = currentBalance + value
        coreDataService.updateNumericField(with: updatedBalance, forKey: .balance)
        view?.updateBalance(updatedBalance)
        let transaction = TransactionModel(
            date: Date(),
            amount: value,
            category: .refill
        )
        coreDataService.saveTransaction(transaction: transaction)
        prepareSections()
    }
    
    func onTapTransactions() {
        router.openModule(ExpenseModule())
    }
    
    func onTapAdd() {
        view?.showInputView(with: InputSlidingViewModel(
            title: Constants.recieveCoins,
            enterAmount: Constants.enterAmount
        ))
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
        sections = []
        let transactions = coreDataService.fetchTransactions().sorted(by: { $0.date > $1.date })
        let groupedTransactions = groupTransactionsByDate(transactions)
        
        groupedTransactions.forEach { (dateCategory, transactionsForCategory) in
            var items = [HomeViewModel.SectionItem]()
            transactionsForCategory.forEach { transaction in
                items.append(HomeViewModel.SectionItem.transaction(transaction))
            }
            sections.append(HomeViewModel.Section(
                type: .transactions(dateCategory),
                items: items
            ))
        }
        
        if transactions.isEmpty {
            view?.comfigureEmptyState(with: Constants.emptyStateTitle)
            return
        }
        
        view?.reloadData(with: sections)
    }
    
    func groupTransactionsByDate(_ transactions: [TransactionModel]) -> [String: [TransactionModel]] {
        var grouped: [String: [TransactionModel]] = [:]
        
        transactions.forEach { transaction in
            let dateCategory = getDateCategory(for: transaction.date)
            if grouped[dateCategory] == nil {
                grouped[dateCategory] = []
            }
            grouped[dateCategory]?.append(transaction)
        }
        
        return grouped
    }
    
    func getDateCategory(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let transactionDate = calendar.startOfDay(for: date)
        
        if calendar.isDate(today, inSameDayAs: transactionDate) {
            return "Today"
        } else if calendar.isDateInYesterday(transactionDate) {
            return "Yesterday"
        } else {
            let components = calendar.dateComponents([.day], from: transactionDate, to: today)
            if let daysAgo = components.day {
                return "\(daysAgo) days ago"
            }
            return "Older"
        }
    }
    
    func configureHeader() {
        let headerViewModel = HomeHeaderViewModel(
            coinName: Constants.coinName,
            balance: currentBalance,
            priceTitle: Constants.priceTitle,
            currentPrice: (Constants.dollarSign + String(format: "%.3f", currentPrice)),
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
        static let recieveCoins: String = "Recieve Coins"
        static let enterAmount: String = "Enter amount of btc"
        static let emptyStateTitle: String = "No transactions has been made yet.."
    }
}
