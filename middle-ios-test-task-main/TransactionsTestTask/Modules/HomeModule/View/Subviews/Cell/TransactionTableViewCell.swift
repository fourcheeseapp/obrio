//
//  TransactionTableViewCell.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.purpleLight?.cgColor
        return view
    }()
    private let timeLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .gray
        return view
    }()
    private let amountLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    private let categoryLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .regular)
        view.textColor = Colors.purpleLight
        return view
    }()
    private let categoryLogo: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 32, weight: .black)
        view.textColor = .white
        return view
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TransactionModel) {
        timeLabel.text = model.time
        categoryLogo.text = model.category.logo
        categoryLabel.text = model.category.rawValue.capitalized
        let isRefill = model.category == .refill
        amountLabel.text = "\((isRefill ? Constants.positiveSign : Constants.negativeSign)) \(String(model.amount)) \(Constants.btcSign)"
        amountLabel.textColor = isRefill ? Colors.lightGreen : .systemRed
    }
}

private extension TransactionTableViewCell {
    func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(categoryLogo)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
        categoryLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(categoryLogo.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        amountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(timeLabel.snp.bottom).offset(16)
        }
    }
    
    // MARK: - Constants
    enum Constants {
        static let negativeSign = "-"
        static let positiveSign = "+"
        static let btcSign: String = "btc"
    }
}
