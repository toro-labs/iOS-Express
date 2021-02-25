//
//  CoreDataRepository.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 21/1/21.
//

import CoreData
import Foundation

enum CoreDataError: Error {
    case invalidRequest
}

final class CoreDataRepository {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension CoreDataRepository: PersistanceRepository {
    func get<T: NSManagedObject>(type: T.Type, fetchArgs: ClientRequest) throws -> [T] {
        guard let date = fetchArgs.date else {
            throw CoreDataError.invalidRequest
        }
        
        let fetchRequest = NSFetchRequest<T>(entityName: "\(type)")

        let carPredicate = NSPredicate(format: "car = %@", fetchArgs.model)
        let datePredicate = NSPredicate(format: "%d >= fromDate && %d <= toDate", date, date)
        let rentPredicate = NSPredicate(format: "rented = %@", NSNumber(value: true))
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [carPredicate, datePredicate, rentPredicate])
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error
        }
    }
    
    func save() {}
    
    
    func updateRent(for rent: RentModel) {
        rent.rented = false
        do {
            try context.save()
        } catch {
            print("Error ocurred")
        }
    }
    
}
