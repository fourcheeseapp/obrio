//
//  ExpenseViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import UIKit
import SnapKit

protocol ExpenseView: AnyObject {
    func configurePicker(with data: [TransactionModel.TransactionCategory])
    func configure(with viewModel: ExpenseViewModel)
    func showError(with message: String)
}

final class ExpenseViewController: BaseViewController {
    private let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .never
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18, weight: .medium)
        textField.textColor = .black
        textField.tintColor = .black
        textField.spellCheckingType = .no
        textField.keyboardType = .decimalPad
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        return textField
    }()
    private lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.purpleLight
        button.setTitleColor(
            Colors.mainBackground,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didTapAddButton),
            for: .touchUpInside
        )
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        button.layer.cornerRadius = 24
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Assets.backButton?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapbackButton),
            for: .touchUpInside
        )
        button.backgroundColor = .clear
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var categories = [TransactionModel.TransactionCategory]()
    
    var presenter: ExpenseViewPresenterProtocol?
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNotifications()
        presenter?.onViewdidload()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - ExpenseView
extension ExpenseViewController: ExpenseView {
    func configure(with viewModel: ExpenseViewModel) {
        titleLabel.text = viewModel.title
        addButton.setTitle(viewModel.addButtonTitle, for: .normal)
        textField.placeholder = viewModel.enterAmountPlaceholder
    }
    
    func configurePicker(with data: [TransactionModel.TransactionCategory]) {
        categories = data
    }
    
    func showError(with message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension ExpenseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = "\(categories[row].logo) \(categories[row].rawValue.capitalized)"
        return NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white])
    }
}

// MARK: - Private
private extension ExpenseViewController {
    // MARK: - Actions
    @objc
    func didTapAddButton() {
        guard let text = textField.text, let amount = Double(text) else { return }
        let selectedCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
        let transaction = TransactionModel(
            date: Date(),
            amount: amount,
            category: selectedCategory
        )
        presenter?.didAddTransaction(transaction)
    }
    
    @objc
    func didTapbackButton() {
        presenter?.didTapBack()
    }
    
    // MARK: - Methods
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(categoryPicker)
        view.addSubview(addButton)
        view.addSubview(textFieldContainer)
        textFieldContainer.addSubview(textField)
        view.addSubview(backButton)
    }
    
    func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(68)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        categoryPicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(48)
            $0.height.equalTo(148)
        }
        textFieldContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(48)
            $0.height.equalTo(48)
            $0.top.equalTo(categoryPicker.snp.bottom).offset(24)
        }
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        addButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.addButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + 16)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.addButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(48)
            }
            self.view.layoutIfNeeded()
        }
    }
}
