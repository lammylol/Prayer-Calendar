//
//  PrayerCalendarSwiftApp.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI
import SwiftData

@main
struct PrayerCalendarSwiftApp: App {
    @State private var dataHolder = DataHolder()
//    let container: ModelContainer = {
//        let schema = Schema([UserPrayerProfile.self])
//        let config = ModelConfiguration(allowsSave: true)
//        let container = try! ModelContainer(for: schema, configurations: config)
//        return container
//    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataHolder)
        }
//        .modelContainer(container)
    }
}
