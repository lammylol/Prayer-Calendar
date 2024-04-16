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
//    @State private var userHolder = UserProfileHolder()
//    @State private var dataHolder = PrayerListHolder()
    
//    let container: ModelContainer = {
//        let schema = Schema([PrayerRequestViewModel.self])
//        let config = ModelConfiguration(allowsSave: true)
//        let container = try! ModelContainer(for: schema, configurations: config)
//        return container
//    }()
    
    init(){
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environment(UserProfileHolder())
                .environment(PrayerListHolder())
                .environment(DateHolder())
                .environment(PrayerRequestViewModel())
//                .environment(PrayerRequestsHolder())
        }
    }
}
