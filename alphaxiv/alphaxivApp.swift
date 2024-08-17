//
//  alphaxivApp.swift
//  alphaxiv
//
//  Created by Kuan Zhou on 8/18/24.
//

import SwiftUI

@main
struct alphaxivApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
