//
//  PrayerCalendarSwiftApp.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct PrayerCalendarSwiftApp: App {
    @State private var dataHolder = DataHolder()
    let container: ModelContainer = {
        let schema = Schema([PrayerRequest.self])
        let config = ModelConfiguration(allowsSave: true)
        let container = try! ModelContainer(for: schema, configurations: config)
        return container
    }()
    
    init(){
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environment(dataHolder)
        }
        .modelContainer(container)
    }
}
