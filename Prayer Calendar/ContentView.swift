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
//    @Environment(DateHolder.self) var dateHolder
    
    var body: some View {
        //Tabs for each view. Adds bottom icons.
        TabView {
            PrayerCalendarView()
                .tabItem {
                    Image(systemName: "calendar.circle")
                        .imageScale(.large)
                    Text("Calendar")
//                        .onTapGesture {
//                            dateHolder.date = Date()
//                        }
                }
            PrayerNameInputView(dataHolder: prayerListHolder)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                        .imageScale(.large)
                    Text("People List")
                }
            ProfileView(person: userHolder.person)
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
        .environment(PrayerListHolder())
        .environment(UserProfileHolder())
//        .environment(PrayerRequestsHolder())
}
