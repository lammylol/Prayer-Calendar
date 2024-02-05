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
    @State var person: PrayerPerson
    
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var dataHolder
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("")
                        .toolbar {
                            if person.username == userHolder.person.username {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button(action: {
                                        self.signOut()
                                    }) {Text("logout")
                                            .bold()
                                            .font(.system(size: 14))
                                            .frame(width: 60, height: 25)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(Color.blue)
                                            )
                                            .foregroundColor(.white)
                                    }
                                }
//                                ToolbarItem(){
//                                    Button(action: {
//                                        Task {
//                                            await ReloadPrayerRequests().updateRequests()
//                                        }
//                                    }) {Text("Run Data Migration")
//                                    }
//                                    .padding(.top, 10)
//                                }
                            }
                        }
                    
                    HStack {
                        Text(usernameDisplay())
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .font(.system(size: 14))
                    .italic()
                    
                    Spacer()
                
                    PrayerRequestsView(person: person)
                        .frame(maxHeight: .infinity)
                        .padding(.top, 20)
                }
            }
            .navigationTitle(person.firstName + " " + person.lastName)
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    func signOut() {
        // Sign out from firebase and change loggedIn to return to SignInView.
        try? Auth.auth().signOut()
        resetInfo()
    }
                    
    func resetInfo() {
        userHolder.friendsList = []
        userHolder.isLoggedIn = false
        
        dataHolder.userID = ""
        dataHolder.prayerList = ""
        dataHolder.prayStartDate = Date()
    }
    
    func usernameDisplay() -> String {
        
        if person.username == "" {
            return "no active profile linked via username. data will be stored under your own account."
        } else {
            return "username: \(person.username)"
        }
    }
}

#Preview {
    ProfileView(person: PrayerPerson(userID: "aMq0YdteGEbYXWlSgxehVy7Fyrl2", username: "lammylol"))
        .environment(UserProfileHolder())
        .environment(PrayerListHolder())
}
