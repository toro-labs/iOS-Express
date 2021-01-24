//
//  EnvironmentKey.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 23/1/21.
//

import SwiftUI

struct AvailableCars: EnvironmentKey {
    static var defaultValue: [String] = ["Honda CRV 2000", "Honda CRV 2004", "Honda CRV 2010", "NIssan Xtrail"]
}

extension EnvironmentValues {
    var availableCars: [String] {
        get { self[AvailableCars.self] }
        set { self[AvailableCars.self] = newValue }
    }
}
