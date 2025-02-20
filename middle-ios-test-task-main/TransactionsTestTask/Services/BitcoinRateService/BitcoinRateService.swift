//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coincap.io/v2/assets/bitcoin
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// The service should be covered by unit tests

import Foundation
import Combine

protocol BitcoinRateService: AnyObject {
    func startMonitoringPrice()
    func stopMonitoringPrice()
    var ratePublisher: AnyPublisher<Result<Double, BaseError>, Never> { get }
}

final class BitcoinRateServiceImpl {
    private let coreDataService = ServicesAssembler.coreDataService()
    private var rateSubject = PassthroughSubject<Result<Double, BaseError>, Never>()
    private var cancellables = Set<AnyCancellable>()
    var ratePublisher: AnyPublisher<Result<Double, BaseError>, Never> {
        return rateSubject.eraseToAnyPublisher()
    }
}

// MARK: - BitcoinRateService
extension BitcoinRateServiceImpl: BitcoinRateService {
    func stopMonitoringPrice() {
        cancellables.removeAll()
    }
    
    func startMonitoringPrice() {
        fetchBitcoinRate()
        Timer.publish(every: 120, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchBitcoinRate()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension BitcoinRateServiceImpl {
    func fetchBitcoinRate() {
        guard let url = URL(string: Constants.requestURL) else {
            rateSubject.send(.failure(.invalidURL(Constants.invalidURLMessage)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                self?.rateSubject.send(.failure(.generalError(error.localizedDescription)))
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                self?.rateSubject.send(.failure(.noData(Constants.noDataMessage)))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(BitcoinRateResponse.self, from: data)
                let rate = Double(json.data.priceUsd) ?? 0
                self?.coreDataService.updateNumericField(with: rate, forKey: .currentPrice)
                self?.rateSubject.send(.success(rate))
            } catch {
                self?.rateSubject.send(.failure(.decodingError(Constants.decodingErrorMessage)))
            }
        }
        task.resume()
    }
}

// MARK: - BaseError
enum BaseError: Error {
    case invalidURL(String)
    case generalError(String)
    case noData(String)
    case decodingError(String)
}


// MARK: - Constants
private extension BitcoinRateServiceImpl {
    enum Constants {
        static let requestURL = "https://api.coincap.io/v2/assets/bitcoin"
        static let invalidURLMessage: String = "Invalid URL"
        static let noDataMessage: String = "No data received"
        static let decodingErrorMessage: String = "Decoding error"
    }
}
