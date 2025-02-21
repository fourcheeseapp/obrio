//
//  RouterProtocol.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import UIKit

protocol RouterProtocol: AnyObject {
    var viewController: UIViewController? { get }
    func openModule(_ module: BaseModule, animated: Bool)
    func close(animated: Bool, completion: Callback?)
}
