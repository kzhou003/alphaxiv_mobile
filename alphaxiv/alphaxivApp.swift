//
//  alphaxivApp.swift
//  alphaxiv
//
//  Created by Kuan Zhou on 8/18/24.
//

import SwiftUI
import SwiftData

@main
struct AlphaXivApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([ArXivPaper.self, Comment.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            PaperListView()
        }
        .modelContainer(container)
    }
}