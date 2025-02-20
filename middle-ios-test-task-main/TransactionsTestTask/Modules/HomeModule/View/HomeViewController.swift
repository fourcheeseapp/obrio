//
//  HomeViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit
import SnapKit

protocol HomeView: AnyObject {
    func configureHeader(with model: HomeHeaderViewModel)
    func reloadData(with sections: [HomeViewModel.Section])
}

final class HomeViewController: BaseViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.SectionType, HomeViewModel.SectionItem>
    private lazy var headerView: HomeHeaderView = {
       let view = HomeHeaderView()
        view.delegate = self
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        let inset: CGFloat = 16
        tableView.contentInset = UIEdgeInsets(
            top: inset,
            left: .zero,
            bottom: inset,
            right: .zero
        )
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    private var dataSource: TeacherCreateHomeworkViewDataSource!
    
    var presenter: HomeViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.onViewDidLoad()
    }
}

// MARK: - HomeView
extension HomeViewController: HomeView {
    func reloadData(with sections: [HomeViewModel.Section]) {
        var snapshot = Snapshot()
        sections.forEach { section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.items, toSection: section.type)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureHeader(with model: HomeHeaderViewModel) {
        headerView.configure(with: model)
    }
}

// MARK: - HomeHeaderViewDelegate
extension HomeViewController: HomeHeaderViewDelegate {
    func didTapTransactions() {
        presenter?.onTapTransactions()
    }
   
    func didTapAdd() {
        presenter?.onTapAdd()
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
}

// MARK: - Privates
private extension HomeViewController {
    func setupUI() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        dataSource = TeacherCreateHomeworkViewDataSource(tableView: tableView)
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}
