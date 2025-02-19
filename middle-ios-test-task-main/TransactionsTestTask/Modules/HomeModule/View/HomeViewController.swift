//
//  HomeViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit
import SnapKit

protocol HomeView: AnyObject {
    
}

final class HomeViewController: BaseViewController {
    private let headerView = HomeHeaderView()
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
    
}

// MARK: - Privates
private extension HomeViewController {
    func setupUI() {
        view.addSubview(headerView)
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
    }
}
