//
//  UIWIndow+Ext.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

extension UIWindow {
    func replaceRootViewControllerWith(
        _ replacementController: UIViewController,
        animated: Bool,
        completion: Callback? = nil
    ) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        addSubview(snapshotImageView)
        
        let dismissCompletion: Callback = {
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                UIView.animate(
                    withDuration: 0.2,
                    animations: { snapshotImageView.alpha = 0 },
                    completion: { _ in
                        snapshotImageView.removeFromSuperview()
                        completion?()
                    }
                )
            } else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if let rootViewController = rootViewController, rootViewController.presentedViewController != nil {
            rootViewController.dismiss(animated: false, completion: dismissCompletion)
        } else {
            dismissCompletion()
        }
    }
}
