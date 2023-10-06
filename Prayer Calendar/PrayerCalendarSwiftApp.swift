//
//  PrayerCalendarSwiftApp.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI

@main
struct PrayerCalendarSwiftApp: App {
    
    var body: some Scene {
        WindowGroup {
            let dataHolder = DataHolder()
            ContentView()
                .environmentObject(dataHolder)
        }
    }
}
