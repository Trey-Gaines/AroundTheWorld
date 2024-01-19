// I used image from NASA as app image. The specific link was from:
// https://unsplash.com/photos/photo-of-outer-space-Q1p7bh3SHj8
//
//  AroundTheWorldApp.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/16/24.
//

import SwiftUI
import SwiftData

@main
struct AroundTheWorldApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true //Set default DarkMode for App
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Game.self,
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
            //Allows the preferred Color Scheme to be modified, but will default to darkMode
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(sharedModelContainer)
    }
}
