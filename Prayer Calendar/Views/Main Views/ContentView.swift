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
    @Environment(UserProfileHolder.self) var prayerListHolder
    @State var selection: Int
//    @Environment(DateHolder.self) var dateHolder
    
    var body: some View {
        //Tabs for each view. Adds bottom icons.
        TabView(selection: $selection) {
            PrayerCalendarView()
                .tabItem {
                    Image(systemName: "house.fill")
                        .imageScale(.large)
                    Text("Calendar")
                }.tag(1)
            PrayerFeedView(person: userHolder.person)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                        .imageScale(.large)
                    Text("Feed")
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
    ContentView(selection: 1)
        .environment(UserProfileHolder())
        .environment(UserProfileHolder())
//        .environment(PrayerRequestsHolder())
}
