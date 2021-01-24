//
//  CarModel.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 23/1/21.
//

import Foundation

enum CarModel: String, CaseIterable, Identifiable {
    case honda2000
    case honda2004
    case honda2010
    case nissan

    var id: String { self.rawValue }
}
