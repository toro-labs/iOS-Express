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
    
    private let respository: PersistanceRepository
    
    @Published var showPhoneAlert: Bool
    
    init(repository: PersistanceRepository) {
        self.respository = repository
        self.showPhoneAlert = false
    }
    
    convenience init() {
        self.init(repository: CoreDataRepository(context: PersistenceController.shared.container.viewContext))
    }
    
    func getClient(from request: ClientRequest) -> ClientModel? {
        do {
            let rent = try self.respository.get(type: RentModel.self, fetchArgs: request)
            
            return rent.compactMap {
                return $0.client
            }.first
        } catch {
            return nil
        }
    }
}
