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
    let fromDate: Date?
    let toDate: Date?
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
        self.actualDate = Date()
        self.respository = repository
        self.selectedCar = CarModel.honda2010
        self.showPhoneAlert = false
    }
    
    convenience init() {
        self.init(repository: CoreDataRepository(context: PersistenceController.shared.container.viewContext))
    }
    
    // MARK: Setup
    
    func getClient() {
        let request = ClientRequest(model: self.selectedCar.rawValue, fromDate: DateUtil.shared.getStartDay(self.actualDate), toDate: DateUtil.shared.getEndDay(self.actualDate))
        do {
            let rent = try self.respository.get(type: RentModel.self, fetchArgs: request)
            self.rent = rent.first
        } catch {
            self.rent = nil
        }
    }
    
    func getOcupationDate() -> (Date, Date) {
        guard let rent = self.rent else { return (self.actualDate, self.actualDate) }
        return (rent.fromDate!, rent.toDate!)
    }
    
    func nextDay() {
        self.actualDate = self.actualDate.addingTimeInterval(Constant.daySeconds)
    }
    
    func previousDay() {
        self.actualDate = self.actualDate.addingTimeInterval(-Constant.daySeconds)
    }
}
