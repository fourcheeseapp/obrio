//
//  SplashViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit
import SnapKit

protocol SplashView: AnyObject {
    func setupTitle(_ title: String)
}

final class SplashViewController: BaseViewController {
    private let logoImageView: UIImageView = {
        let view = UIImageView(image: Assets.splashLogo)
        view.backgroundColor = .clear
        view.contentMode = .scaleToFill
        return view
    }()
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    var presenter: SplashViewPresenterProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        presenter?.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
}

// MARK: - SplashView
extension SplashViewController: SplashView {
    func setupTitle(_ title: String) {
        titleLabel.text = title 
    }
}

// MARK: - Privates
private extension SplashViewController {
    func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(1)
        }
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func animateLogo() {
        logoImageView.snp.updateConstraints {
            $0.size.equalTo(124)
        }
        
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
        })
        
        onMainQueue(after: .now() + 2) { [weak self] in
            guard let self else { return }
            self.logoImageView.snp.remakeConstraints {
                $0.size.equalTo(54)
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            }
            
            UIView.animate(withDuration: 2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
}
