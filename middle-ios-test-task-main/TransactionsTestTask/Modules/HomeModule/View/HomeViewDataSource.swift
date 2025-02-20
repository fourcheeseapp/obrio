//
//  HomeViewDataSource.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import UIKit

final class TeacherCreateHomeworkViewDataSource: UITableViewDiffableDataSource<HomeViewModel.SectionType, HomeViewModel.SectionItem> {
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .date(let model):
                // TODO: - 
                return UITableViewCell()
            case .transaction(let model):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
                cell.configure(with: model)
                return cell
            }
        }
    }
}
