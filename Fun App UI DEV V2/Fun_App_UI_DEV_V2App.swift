//
//  Fun_App_UI_DEV_V2App.swift
//  Fun App UI DEV V2
//
//  Created by Kaushik Manian on 22/6/25.
//

import SwiftUI
import SwiftData

@main
struct Fun_App_UI_DEV_V2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
