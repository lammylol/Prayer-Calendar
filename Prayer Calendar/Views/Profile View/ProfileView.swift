//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//
// Description: ProfileView with conditional statements changing the view depending on whether it is your profile you are viewing or someone else's.

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var showSubmit: Bool = false
    @State private var showEditView: Bool = false
    @State var person: Person
    
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var dataHolder
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("")
                        .toolbar {
//                            if person.username == userHolder.person.username {
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink(destination: ProfileSettingsView()) {
                                        Image(systemName: "gear")
                                    }
                            }
                        }
                    
                    HStack {
                        Text(usernameDisplay())
                        Spacer()
                    }
                    .padding([.leading, .trailing], 20)
                    .font(.system(size: 14))
                    
                    Spacer()
                    
                    if userHolder.person.username == person.username {
                        ProfilePrayerRequestsView(person: userHolder.person) // Leaving as a separate view for now in case need to implement tab view.
                            .frame(maxHeight: .infinity)
                            .padding(.top, 20)
                    } else {
                        ProfilePrayerRequestsView(person: person) // Leaving as a separate view for now in case need to implement tab view.
                            .frame(maxHeight: .infinity)
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle(person.firstName + " " + person.lastName)
            .navigationBarTitleDisplayMode(.automatic)
            .refreshable {
                Task {
                    do {
                        userHolder.refresh = true
                    }
                }
            }
        }
    }
    
    func usernameDisplay() -> String {
        if person.username == "" {
            return "[Private Account]: No active profile linked"
        } else {
            return "[Username]: \(person.username.capitalized)"
        }
    }
}

#Preview {
    ProfileView(person: Person(userID: "aMq0YdteGEbYXWlSgxehVy7Fyrl2", username: "lammylol"))
        .environment(UserProfileHolder())
        .environment(PrayerListHolder())
}
