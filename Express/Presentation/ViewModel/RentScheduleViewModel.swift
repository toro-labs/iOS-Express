//
//  RentScheduleViewModel.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 7/1/21.
//

import Combine
import CoreData

class RentScheduleViewModel: ObservableObject {
    // MARK: - Inner Types
    
    enum PaymentType: String {
        case colons
        case dollars
    }
    
    // MARK: Observable Attributes
    
    @Published var booked: Bool
    @Published var cellphone: String
    @Published var from: Date
    @Published var money: String
    @Published var name: String
    @Published var place: String
    @Published var paymentType: PaymentType
    @Published var selectedCar: CarModel
    @Published var to: Date
    
    // MARK: Life Cycle
    
    init() {
        self.booked = false
        self.cellphone = ""
        self.from = Date()
        self.money = ""
        self.name = ""
        self.place = ""
        self.paymentType = .colons
        self.selectedCar = .honda2010
        self.to = Date()
    }
    
    // MARK: Setup
    
    private func createClient(context: NSManagedObjectContext, idDocument: IDDocument) -> ClientModel {
        let client = ClientModel(context: context)
        client.cellphone = self.cellphone
        client.completeName = self.name
        client.idDocument = idDocument
        
        return client
    }
    
    private func createPayment(context: NSManagedObjectContext) -> Payment {
        let payment = Payment(context: context)
        payment.money = NSDecimalNumber(string: self.money)
        payment.type = self.paymentType.rawValue
        
        return payment
    }
    
    func rent(context: NSManagedObjectContext, idDocument: IDDocument) {
        let rent = RentModel(context: context)
        
        rent.client = self.createClient(context: context, idDocument: idDocument)
        rent.fromDate = self.from
        rent.payment = self.createPayment(context: context)
        rent.car = self.selectedCar.id
        rent.reserved = self.booked
        rent.toDate = self.to
        
        do {
            try context.save()
            self.reset()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        self.booked = false
        self.cellphone = ""
        self.from = Date()
        self.money = ""
        self.name = ""
        self.place = ""
        self.paymentType = .colons
        self.selectedCar = .honda2010
        self.to = Date()
    }
}
