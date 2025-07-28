//
//  Fun_App_UI_DevelopementApp.swift
//  Cultural Bridge Quest
//
//  Created by Kaushik Manian on 19/6/25.
//

import SwiftUI
import SwiftData

@main
struct Fun_App_UI_DevelopementApp: App {
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
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
