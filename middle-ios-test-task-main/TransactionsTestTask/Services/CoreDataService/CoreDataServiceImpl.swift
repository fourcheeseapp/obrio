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
    func updateNumericField(with value: Double, forKey key: Key) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.emtityName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let existingData = results.first {
                existingData.setValue(value, forKey: key.rawValue)
            } else {
                if let entity = NSEntityDescription.entity(forEntityName: Constants.emtityName, in: context) {
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.emtityName)
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
        static let emtityName = "WaletData"
    }
}
