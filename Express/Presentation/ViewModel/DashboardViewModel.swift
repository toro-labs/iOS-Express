//
//  DashboardViewModel.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 6/2/21.
//

import CoreData
import Foundation

struct ClientRequest {
    let model: String
    let date: Int64?
}

class DashboardViewModel: ObservableObject {
    // MARK: - Attributes
    
    private var rent: RentModel?
    
    var client: ClientModel? {
        return self.rent?.client
    }
    
    private let respository: PersistanceRepository
    
    // MARK: Observable Attributes
    
    @Published var actualDate: Date
    @Published var selectedCar: CarModel
    @Published var showPhoneAlert: Bool
    
    // MARK: Life Cycle
    
    init(repository: PersistanceRepository) { // Aquí sería bueno pensar en un DI Framework
        self.actualDate = Date().localDate()
        self.respository = repository
        self.selectedCar = CarModel.honda2010
        self.showPhoneAlert = false
        self.getClient()
    }
    
    convenience init() {
        self.init(repository: CoreDataRepository(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: Setup
    
    func useCache() -> Bool {
        guard let fromDate = self.rent?.fromDate, let toDate = self.rent?.toDate else { return false }
        
        return (Date(timeIntervalSince1970: TimeInterval(fromDate)) ... Date(timeIntervalSince1970: TimeInterval(toDate))).contains(self.actualDate)
    }
    
    func getClient() {
        if !useCache() {
            let request = ClientRequest(model: self.selectedCar.rawValue, date: Int64(self.actualDate.timeIntervalSince1970))
            do {
                let rent = try self.respository.get(type: RentModel.self, fetchArgs: request)
                
                self.rent = rent.first
            } catch {
                self.rent = nil
            }
        }
    }
    
    func getOcupationDate() -> (Date, Date) {
        guard let rent = self.rent else { return (self.actualDate, self.actualDate) }
        return (Date(timeIntervalSince1970: TimeInterval(rent.fromDate)), Date(timeIntervalSince1970: TimeInterval(rent.toDate)))
    }
    
    func nextDay() {
        self.actualDate = self.actualDate.addingTimeInterval(Constant.daySeconds)
    }
    
    func previousDay() {
        self.actualDate = self.actualDate.addingTimeInterval(-Constant.daySeconds)
    }
    
    func isRented() -> Bool {
        guard let rent = self.rent else {
            return false
        }
        return rent.rented
    }
    
    func finishRent() {
        if let rent = self.rent {
            self.respository.updateRent(for: rent)
            self.rent = nil
            self.actualDate = Date().localDate()
        }
    }
}
