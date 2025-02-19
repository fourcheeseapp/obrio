//
//  SplashViewController.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit
import SnapKit

protocol SplashScreenView: AnyObject {
    func setupTitle(_ title: String)
}

final class SplashScreenViewController: BaseViewController {
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
    var presenter: SplashScreenPresenterProtocol?
    
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

// MARK: - SplashScreenView
extension SplashScreenViewController: SplashScreenView {
    func setupTitle(_ title: String) {
        titleLabel.text = title 
    }
}

// MARK: - Privates
private extension SplashScreenViewController {
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
        self.logoImageView.snp.updateConstraints {
            $0.size.equalTo(124)
        }
        
        UIView.animate(withDuration: Consants.animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Constants 
    enum Consants {
        static let animationDuration: TimeInterval = 3
    }
}
