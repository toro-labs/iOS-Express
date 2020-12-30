//
//  ExpressApp.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 30/12/20.
//

import SwiftUI

@main
struct ExpressApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
