//
//  ExpenseViewPresenter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import Foundation

protocol ExpenseViewPresenterProtocol: AnyObject {
    func onViewdidload()
    func didAddTransaction(_ transaction: TransactionModel)
    func didTapBack()
}

final class ExpenseViewPresenter {
    private weak var view: ExpenseView?
    private let router: ExpenseViewRouter
    private let coreDataService = ServicesAssembler.coreDataService()
    
    // MARK: - init
    init(
        view: ExpenseView,
        router: ExpenseViewRouter
    ) {
        self.view = view
        self.router = router
    }
}

// MARK: - ExpenseViewPresenterProtocol
extension ExpenseViewPresenter: ExpenseViewPresenterProtocol {
    func didTapBack() {
        router.close(animated: true, completion: nil)
    }
    
    func didAddTransaction(_ transaction: TransactionModel) {
        if transaction.amount <= 0 {
            view?.showError(with: Constants.incorrectAmount)
            return
        }
        if coreDataService.getValueFromNumericField(forKey: .balance) < transaction.amount {
            view?.showError(with: Constants.notEnoughCoins)
        } else {
            var currentBalance = coreDataService.getValueFromNumericField(forKey: .balance)
            currentBalance -= transaction.amount
            coreDataService.updateNumericField(with: currentBalance, forKey: .balance)
            coreDataService.saveTransaction(transaction: transaction)
            router.close(animated: true, completion: nil)
        }
    }
    
    func onViewdidload() {
        configurePickerData()
        configureView()
    }
}

// MARK: - Private
private extension ExpenseViewPresenter {
    func configurePickerData() {
        view?.configurePicker(with: [
            .groceries, .taxi, .electronics, .restaurant, .other
        ])
    }
    
    func configureView() {
        view?.configure(with: ExpenseViewModel(
            title: Constants.title,
            addButtonTitle: Constants.addButtonTitle,
            enterAmountPlaceholder: Constants.enterAmountPlaceholder
        ))
    }
    
    // MARK: - Constants
    enum Constants {
        static let title: String = "Chose category \nand enter your expenses"
        static let addButtonTitle: String = "Add"
        static let enterAmountPlaceholder: String = "Enter amount"
        static let incorrectAmount: String = "Incorrect amount"
        static let notEnoughCoins: String = "Not enough coins. Please add more"
    }
}
