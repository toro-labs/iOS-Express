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
    
    var dateComponentes: [String] {
        return DateUtil.shared.getDateComponents(actualDate)
    }
    
    private var rent: RentModel?
    
    var client: ClientModel? {
        return rent?.client
    }
    
    private let respository: PersistanceRepository
    
    @Published var actualDate: Date
    @Published var showPhoneAlert: Bool
    @Published var selectedCar: CarModel
    
    init(repository: PersistanceRepository) {
        self.actualDate = Date()
        self.respository = repository
        self.selectedCar = CarModel.honda2010
        self.showPhoneAlert = false
    }
    
    convenience init() {
        self.init(repository: CoreDataRepository(context: PersistenceController.shared.container.viewContext))
    }
    
    func getClient() {
        let request = ClientRequest(model: self.selectedCar.rawValue, fromDate: DateUtil.shared.getStartDay(actualDate), toDate: DateUtil.shared.getEndDay(actualDate))
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
