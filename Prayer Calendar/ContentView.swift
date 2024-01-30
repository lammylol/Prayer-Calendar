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
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var prayerListHolder
    @State var selection = 1
//    @Environment(DateHolder.self) var dateHolder
    
    var body: some View {
        //Tabs for each view. Adds bottom icons.
        TabView(selection: $selection) {
            PrayerFeedView(person: userHolder.person)
                .tabItem {
                    Image(systemName: "house.fill")
                        .imageScale(.large)
                    Text("Prayer Feed")
                }.tag(1)
            PrayerCalendarView()
                .tabItem {
                    Image(systemName: "calendar.circle")
                        .imageScale(.large)
                    Text("Calendar")
//                        .onTapGesture {
//                            dateHolder.date = Date()
//                        }
                }.tag(2)
            ProfileView(person: userHolder.person)
                .tabItem {
                    Image(systemName: "person.circle")
                        .imageScale(.large)
                    Text("Profile")
                }.tag(3)
        }
    }
}

#Preview("Content View") {
    ContentView()
        .environment(PrayerListHolder())
        .environment(UserProfileHolder())
//        .environment(PrayerRequestsHolder())
}
