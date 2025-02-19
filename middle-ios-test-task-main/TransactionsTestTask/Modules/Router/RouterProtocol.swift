//
//  RouterProtocol.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

protocol RouterProtocol: AnyObject {
    var viewController: UIViewController? { get }
    func openModule(_ module: BaseModule, needPinCode: Bool, animated: Bool)
    func replaceRootModule(with module: BaseModule?, animated: Bool, completion: Callback?)
    func close(animated: Bool, completion: Callback?)
}
