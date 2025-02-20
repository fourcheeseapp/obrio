//
//  SliderView.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import UIKit

protocol InputSlidingViewDelegate: AnyObject {
    func onDissmiss()
    func didAdd(_ amount: Double)
}

final class InputSlidingView: UIView {
    private let slideView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.mainBackground
        view.roundTop(24)
        return view
    }()
    private let islandView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.purpleLight
        view.layer.cornerRadius = 2
        return view
    }()
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.alpha = .zero
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
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
    
    weak var delegate: InputSlidingViewDelegate?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGestureRecognizers()
        setupNotifications()
#warning("!!!")
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        showSlidingView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure() {
        titleLabel.text = "Recieve Coins"
        addButton.setTitle("Recieve coins", for: .normal)
        textField.placeholder = "Enter amount of btc"
    }
}

// MARK: - Privates
private extension InputSlidingView {
    // MARK: - Actions
    @objc
    func didTapAddButton() {
        guard let inputText = textField.text else { return }
        let formattedText = inputText.replacingOccurrences(of: ",", with: ".")
        guard let inputValue = Double(formattedText) else { return }
        delegate?.didAdd(inputValue)
        hideSlidingView()
    }
    
    @objc
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        hideSlidingView()
        onMainQueue(after: .now() + Constants.animationDuration, { [weak self] in
            self?.delegate?.onDissmiss()
        })
    }
    
    @objc
    func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            hideSlidingView()
            onMainQueue(after: .now() + Constants.animationDuration, { [weak self] in
                self?.delegate?.onDissmiss()
            })
        }
    }
    
    // MARK: - Methods
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        visualEffectView.addGestureRecognizer(tapGesture)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureRecognizer.direction = .down
        slideView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func hideSlidingView() {
        endEditing(true)
        UIView.animate(withDuration: Constants.animationDuration) {
            self.visualEffectView.alpha = .zero
            self.slideView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(-self.slideView.bounds.height)
            }
            self.layoutSubviews()
        }
    }
    
    func showSlidingView() {
        UIView.animate(withDuration: Constants.animationDuration, animations: {
            self.slideView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.visualEffectView.alpha = 1
            self.layoutSubviews()
        })
    }
    
    func setupUI() {
        backgroundColor = .clear
        addSubview(visualEffectView)
        addSubview(slideView)
        slideView.addSubview(islandView)
        slideView.addSubview(titleLabel)
        slideView.addSubview(textFieldContainer)
        slideView.addSubview(addButton)
        textFieldContainer.addSubview(textField)
    }
    
    func setupConstraints() {
        visualEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        slideView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-400)
        }
        islandView.snp.makeConstraints {
            $0.height.equalTo(4)
            $0.width.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(islandView.snp.bottom).offset(24)
        }
        textFieldContainer.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(48)
            $0.height.equalTo(48)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(addButton.snp.top).inset(-48)
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
        let safeAreaBottomInset = safeAreaInsets.bottom
        
        UIView.animate(withDuration: animationDuration) {
            self.slideView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardHeight - safeAreaBottomInset + 16)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.slideView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Constants
private extension InputSlidingView {
    enum Constants {
        static let animationDuration: Double = 0.24
    }
}

