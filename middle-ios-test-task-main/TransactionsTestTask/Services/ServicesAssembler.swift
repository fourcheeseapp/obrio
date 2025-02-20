//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
enum ServicesAssembler {
    
    // MARK: - BitcoinRateService
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        let service = BitcoinRateServiceImpl()
        return { service }
    }()
    
    // MARK: - CoreDataService
    static let coreDataService: PerformOnce<CoreDataService> = {
        let service = CoreDataServiceImpl()
        return { service }
    }()
    
}
