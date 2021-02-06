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
        guard let fromDate = fetchArgs.fromDate, let toDate = fetchArgs.toDate else {
            throw CoreDataError.invalidRequest
        }
        
        let fetchRequest = NSFetchRequest<T>(entityName: "\(type)")
        
        fetchRequest.predicate = NSPredicate(format: "car == %@ && fromDate > %@ && fromDate < %@", fetchArgs.model, fromDate as CVarArg, toDate as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error
        }
    }
    
    func save() {}
}
