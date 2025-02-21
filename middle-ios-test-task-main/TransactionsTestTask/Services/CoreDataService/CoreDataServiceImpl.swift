//
//  CoreDataService.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import Foundation
import CoreData

protocol CoreDataService: AnyObject {
    func updateNumericField(with value: Double, forKey key: Key)
    func getValueFromNumericField(forKey key: Key) -> Double
    func saveTransaction(transaction: TransactionModel)
    func fetchTransactions() -> [TransactionModel]
}

final class CoreDataServiceImpl {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension CoreDataServiceImpl: CoreDataService {
    func saveTransaction(transaction: TransactionModel) {
        let newTransaction = Transaction(context: context)
        newTransaction.date = transaction.date
        newTransaction.amount = transaction.amount
        newTransaction.category = transaction.category.rawValue
        
        do {
            try context.save()
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
    }
    
    func fetchTransactions() -> [TransactionModel] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { transaction in
                TransactionModel(
                    date: transaction.date ?? Date(),
                    amount: transaction.amount,
                    category: TransactionModel.TransactionCategory(rawValue: transaction.category ?? "") ?? .other
                )
            }
        } catch {
            print("Failed to fetch transactions: \(error.localizedDescription)")
            return []
        }
    }
    
    func updateNumericField(with value: Double, forKey key: Key) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.waletEntityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingData = results.first {
                existingData.setValue(value, forKey: key.rawValue)
            } else {
                if let entity = NSEntityDescription.entity(forEntityName: Constants.waletEntityName, in: context) {
                    let newData = NSManagedObject(entity: entity, insertInto: context)
                    newData.setValue(value, forKey: key.rawValue)
                }
            }
            try context.save()
        } catch {
            print("Failed to save data to Core Data: \(error.localizedDescription)")
        }
    }
    
    func getValueFromNumericField(forKey key: Key) -> Double {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.waletEntityName)
        do {
            if let result = try context.fetch(fetchRequest).first {
                if let balance = result.value(forKey: key.rawValue) as? Double {
                    return balance
                }
            }
        } catch {
            print("Failed to fetch data from Core Data: \(error.localizedDescription)")
        }
        return 0
    }
}

// MARK: - Keys
enum Key: String {
    case balance
    case currentPrice
}

// MARK: - Constants
private extension CoreDataServiceImpl {
    enum Constants {
        static let containerName = "TransactionsTestTask"
        static let waletEntityName = "WaletData"
    }
}
