//
//  HelperFunctions.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 19.02.2025.
//

import Foundation

typealias Callback = () -> Void

func onMainQueue(_ block: @escaping Callback) {
    DispatchQueue.main.async(execute: block)
}

func onMainQueue(after deadline: DispatchTime, _ block: @escaping Callback) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: block)
}

func onGlobalQueue(_ qos: DispatchQoS.QoSClass, block: @escaping Callback) {
    DispatchQueue.global(qos: qos).async(execute: block)
}
