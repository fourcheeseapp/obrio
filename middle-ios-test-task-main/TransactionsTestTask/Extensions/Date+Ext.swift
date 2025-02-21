//
//  Date+Ext.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 21.02.2025.
//

import Foundation

extension Date {
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
}
