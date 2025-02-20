//
//  HomeView.swift
//  TransactionsTestTask
//
//  Created by Viktor Golovach on 20.02.2025.
//

import Foundation

enum HomeViewModel {
    enum SectionType: Hashable {
       case date(String)
       case transactions(String)
    }
    
    enum SectionItem: Hashable {
        case date(String)
        case transaction(TransactionModel)
    }
    
    struct Section {
        let type: SectionType
        var items: [SectionItem]
    }
}

struct TransactionModel: Hashable {
    let id = UUID().uuidString
    let time: String
    let amount: Double
    let category: TransactionCategory
    
    enum TransactionCategory: String {
        case groceries
        case taxi
        case electronics
        case restaurant
        case other
        case refill
        
        var logo: String {
            return switch self {
            case .groceries:
                "🛍"
            case .taxi:
                "🚕"
            case .electronics:
                "📱"
            case .restaurant:
                "🍣"
            case .other:
                "🤌"
            case .refill:
                "🤑"
            }
        }
    }
}
