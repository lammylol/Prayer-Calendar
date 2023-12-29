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
    @State private var showView: Bool = false
    @State private var showEditView: Bool = false
    @State var person: PrayerPerson
    
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var dataHolder
    
    var body: some View {
        NavigationStack {
            //                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
            ScrollView {
                VStack {
                    Text("")
                        .toolbar {
//                            if userHolder.email == person.username {
                            ToolbarItem(placement: .topBarLeading) {
                                // user view of own profile
                                NavigationLink(destination: PrayerNameInputView(dataHolder: dataHolder)){
                                    Image(systemName: "list.bullet.rectangle")
                                }
                            }
//                                }
                                
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
                            }
//                        }
                    
                HStack {
                    Text(person.firstName).padding(.leading, 20)
                        .font(.system(size: 15))
                        .italic()
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("Prayer Requests")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    Button(action: { showView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.trailing, 15)
                }
                    
                Divider()
                
                    PrayerRequestsView(userID: person.userID)
                .frame(height: 1000)
                .sheet(isPresented: $showView) {
                    SubmitPrayerRequestForm()
                }
            }
            }
            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.automatic)
        }
//        .onAppear() {
//            person.userID = PrayerPersonHelper().retrieveUserID(username: person.username)
//        }
    }
    
    func signOut() {
        // Sign out from firebase and change loggedIn to return to SignInView.
        try? Auth.auth().signOut()
        dataHolder.prayerList = ""
        userHolder.isLoggedIn = false
    }
                    
    func resetInfo() {
        dataHolder.prayerList = ""
        dataHolder.prayStartDate = Date()
    }
}

#Preview {
    ProfileView(person: PrayerPerson.preview/*, userID: ""*/)
        .environment(UserProfileHolder())
        .environment(PrayerListHolder())
}
