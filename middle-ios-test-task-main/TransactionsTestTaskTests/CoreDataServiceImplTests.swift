//
//  CoreDataServiceImplTests.swift
//  TransactionsTestTaskTests
//
//  Created by Viktor Golovach on 21.02.2025.
//

import XCTest
import CoreData
@testable import TransactionsTestTask

class CoreDataServiceImplTests: XCTestCase {

    var sut: CoreDataServiceImpl!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        let container = NSPersistentContainer(name: "TransactionsTestTask")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        // Use the in-memory context for testing
        sut = CoreDataServiceImpl()
        context = sut.context
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }
    
    func test_saveAndFetchTransaction() {
        // arrange
        let expectedTransactionsCount = sut.fetchTransactions().count + 1
        let transaction = TransactionModel(
            date: Date(),
            amount: 100.0,
            category: .electronics
        )

        // act
        sut.saveTransaction(transaction: transaction)
        let fetchedTransactions = sut.fetchTransactions()

        // assert
        XCTAssertEqual(fetchedTransactions.count, expectedTransactionsCount)
        XCTAssertEqual(fetchedTransactions.first?.amount, transaction.amount)
        XCTAssertEqual(fetchedTransactions.first?.category, transaction.category)
    }
    
    func test_updateBalance() {
        // arrange
        let currentBalance = sut.getValueFromNumericField(forKey: .balance)
        let additionalValue: Double = 50
        let expectedBalance = currentBalance + additionalValue
        
        // act
        sut.updateNumericField(with: currentBalance + additionalValue, forKey: .balance)
        let updatedBalance = sut.getValueFromNumericField(forKey: .balance)
        
        // assert
        XCTAssertEqual(updatedBalance, expectedBalance)
    }
    
    func test_updatePrice() {
        // arrange
        let newPrice: Double = 500000
        
        // act
        sut.updateNumericField(with: newPrice, forKey: .currentPrice)
        let updatedPrice = sut.getValueFromNumericField(forKey: .currentPrice)
        
        // assert
        XCTAssertEqual(updatedPrice, newPrice)
    }
}
