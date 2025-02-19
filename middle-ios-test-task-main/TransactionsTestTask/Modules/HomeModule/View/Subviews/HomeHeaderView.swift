//
//  HomeHeaderView.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit
import SnapKit

final class HomeHeaderView: UIView {
    private let coinNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .gray
        return view
    }()
    private let balanceValueLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .white
        return view
    }()
    private let priceTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .regular)
        view.textColor = .gray
        return view
    }()
    private let priceValueLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .medium)
        view.textColor = .white
        return view
    }()
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: Assets.splashLogo)
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        return view
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(
            Assets.addButton?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.purpleLight ?? .white),
            for: .normal
        )
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    private lazy var transferButton: UIButton = {
        let button = UIButton()
        button.setImage(
            Assets.transferButton,
            for: .normal
        )
        button.backgroundColor = Colors.purpleLight
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
        return button
    }()
    private let deviderView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.purpleLight?.withAlphaComponent(0.3)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        coinNameLabel.text = "Bitcoin/BTC"
        balanceValueLabel.text = "73.945"
        priceTitleLabel.text = "BTC/USDT"
        priceValueLabel.text = "$129,00"
    }
}

// MARK: - Privates
private extension HomeHeaderView {
    // MARK: - Actions
    @objc
    func didTapAddButton() {
        
    }
    
    @objc
    func didTapTransferButton() {
        
    }
    
    // MARK: - Methods
    func setupUI() {
        self.backgroundColor = .clear
        addSubview(logoImageView)
        addSubview(coinNameLabel)
        addSubview(balanceValueLabel)
        addSubview(priceTitleLabel)
        addSubview(priceValueLabel)
        addSubview(addButton)
        addSubview(transferButton)
        addSubview(deviderView)
    }
    
    func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(54)
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview()
        }
        coinNameLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).inset(-8)
            $0.top.equalToSuperview()
        }
        balanceValueLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).inset(-8)
            $0.bottom.equalTo(logoImageView.snp.bottom)
        }
        priceTitleLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
        }
        priceValueLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(logoImageView.snp.bottom)
        }
        addButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(priceValueLabel.snp.bottom).inset(-16)
            $0.bottom.equalTo(deviderView.snp.top).inset(-4)
        }
        transferButton.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(coinNameLabel.snp.trailing)
            $0.centerY.equalTo(addButton)
        }
        deviderView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
