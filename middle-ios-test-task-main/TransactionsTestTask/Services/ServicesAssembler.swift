//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

import Foundation

/// Services Assembler is used for Dependency Injection
enum ServicesAssembler {
    
    // MARK: - BitcoinRateService
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        let service = BitcoinRateServiceImpl(fetchInterval: Constants.fetchInterval)
        return { service }
    }()
    
    // MARK: - CoreDataService
    static let coreDataService: PerformOnce<CoreDataService> = {
        let service = CoreDataServiceImpl()
        return { service }
    }()
    
}

// MARK: - Private
private extension ServicesAssembler {
    enum Constants {
        static let fetchInterval: TimeInterval = 60
    }
}
