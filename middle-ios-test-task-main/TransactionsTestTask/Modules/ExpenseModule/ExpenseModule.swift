//
//  ExpenseModule.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import UIKit

final class ExpenseModule {
    private let view: ExpenseViewController
    
    init() {
        view = ExpenseViewController()
        let router = ExpenseViewRouter(viewController: view)
        let presenter = ExpenseViewPresenter(
            view: view,
            router: router
        )
        view.presenter = presenter
    }
}

extension ExpenseModule: BaseModule {
    func viewController() -> UIViewController {
        return view
    }
}

