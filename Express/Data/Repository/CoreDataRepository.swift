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
        let datePredicate = NSPredicate(format: "%@ >= fromDate && %@ <= toDate", date as NSDate, date as NSDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [carPredicate, datePredicate])
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error
        }
    }
    
    func save() {}
}
