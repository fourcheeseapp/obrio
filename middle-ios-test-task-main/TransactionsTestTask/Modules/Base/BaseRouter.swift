//
//  BaseRouter.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

class BaseRouter: RouterProtocol {
    var viewController: UIViewController?
    var topViewController: UIViewController? {
        if let rootViewController = UIApplication.activeWindow?.rootViewController {
            return searchTopController(for: rootViewController)
        } else {
            return viewController
        }
    }
    
    init() {
        onMainQueue {
            self.viewController = self.topViewController
        }
    }
    
    init(viewController: UIViewController) {
        onMainQueue {
            self.viewController = viewController
        }
    }
    
    func openModule(
        _ module: any BaseModule,
        needPinCode: Bool,
        animated: Bool
    ) {
        onMainQueue { [weak self] in
            guard let self else { return }
            let controller = module.viewController()
            self.viewController?.navigationController?.pushViewController(
                controller,
                animated: animated
            )
        }
    }
    
    func replaceRootModule(
        with module: BaseModule?,
        animated: Bool = true,
        completion: Callback? = nil
    ) {
        guard let module else { return }
        onMainQueue {
            guard let window = UIApplication.activeWindow else { return }
            window.replaceRootViewControllerWith(
                module.viewController(),
                animated: true,
                completion: completion
            )
        }
    }
    
    
    func close(
        animated: Bool,
        completion: Callback?
    ) {
        onMainQueue {
            if let navigationController = self.viewController?.navigationController {
                navigationController.popViewController(animated: animated)
            } else {
                self.viewController?.dismiss(animated: animated, completion: completion)
            }
        }
    }
}

private extension BaseRouter {
    func searchTopController(for controller: UIViewController) -> UIViewController {
        if let presentedViewController = controller.presentedViewController {
            return searchTopController(for: presentedViewController)
        } else if let navigationController = controller as? UINavigationController,
                  let lastViewController = navigationController.viewControllers.last {
            return searchTopController(for: lastViewController)
        } else if let tabBarController = controller as? UITabBarController,
                  let selectedController = tabBarController.selectedViewController {
            return searchTopController(for: selectedController)
        } else {
            return controller
        }
    }
}
