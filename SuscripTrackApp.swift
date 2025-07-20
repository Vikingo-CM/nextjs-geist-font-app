//
//  SuscripTrackApp.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import SwiftUI

@main
struct SuscripTrackApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Request notification permissions on app launch
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                AddSubscriptionView()
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                
                StatsView()
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Stats")
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .accentColor(.blue)
        }
    }
}
