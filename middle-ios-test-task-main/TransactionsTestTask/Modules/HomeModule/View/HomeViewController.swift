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
    func showInputView(with model: InputSlidingViewModel)
    func updateBalance(_ balance: Double)
    func updatePrice(_ price: String)
    func showError(with message: String)
    func comfigureEmptyState(with title: String)
}

final class HomeViewController: BaseViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.SectionType, HomeViewModel.SectionItem>
    private lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.delegate = self
        return view
    }()
    private var inputSlidingView: InputSlidingView?
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.mainBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
    private let eptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    var presenter: HomeViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.onViewDidDissapear()
    }
}

// MARK: - HomeView
extension HomeViewController: HomeView {
    func comfigureEmptyState(with title: String) {
        eptyStateLabel.isHidden = false
        eptyStateLabel.text = title
    }
    
    func showInputView(with model: InputSlidingViewModel) {
        inputSlidingView = InputSlidingView()
        inputSlidingView?.delegate = self
        view.addSubview(inputSlidingView ?? UIView())
        inputSlidingView?.configure(with: model)
        inputSlidingView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showError(with message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updatePrice(_ price: String) {
        headerView.updatePrice(price)
    }
    
    func updateBalance(_ balance: Double) {
        headerView.updateBalance(balance)
    }
    
    func reloadData(with sections: [HomeViewModel.Section]) {
        eptyStateLabel.isHidden = true 
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

// MARK: - InputSlidingViewDelegate
extension HomeViewController: InputSlidingViewDelegate {
    func onDissmiss() {
        inputSlidingView?.removeFromSuperview()
        inputSlidingView = nil 
    }
    
    func didAdd(_ amount: Double) {
        presenter?.didRefillWallet(with: amount)
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

// MARK: - Privates
private extension HomeViewController {
    func setupUI() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(eptyStateLabel)
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
        eptyStateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
