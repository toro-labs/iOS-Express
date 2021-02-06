//
//  PersistanceRepository.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 21/1/21.
//

import CoreData
import Foundation

protocol PersistanceRepository {
    func save()
    func get<T: NSManagedObject>(type: T.Type, fetchArgs: ClientRequest) throws -> [T]
}
