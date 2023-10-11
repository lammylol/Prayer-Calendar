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
    
    var body: some Scene {
        WindowGroup {
            let dataHolder = DataHolder()
            ContentView()
                .environmentObject(dataHolder)
        }
        .modelContainer(for: [UserPrayerProfile.self])
    }
}


struct Previews_PrayerCalendarSwiftApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
