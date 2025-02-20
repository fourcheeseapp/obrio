//
//  BitcoinRateResponse.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import Foundation

struct BitcoinRateResponse: Codable {
    let data: BitcoinRateResponseData
}

struct BitcoinRateResponseData: Codable {
    let priceUsd: String
}
