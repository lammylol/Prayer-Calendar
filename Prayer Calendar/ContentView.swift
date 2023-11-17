//
//  ContentView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/11/23.
//

import Foundation
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(PrayerList.self) var dataHolder
    
    var body: some View {
        //Tabs for each view. Adds bottom icons.
        TabView {
            PrayerCalendarView()
                .tabItem {
                    Image(systemName: "calendar.circle")
                        .imageScale(.large)
                    Text("Calendar")
                }
            ProfileView(username: dataHolder.email)
                .tabItem {
                    Image(systemName: "person.circle")
                        .imageScale(.large)
                    Text("Profile")
                }
        }
    }
}

#Preview("Content View") {
    ContentView()
        .environment(PrayerList())
}
