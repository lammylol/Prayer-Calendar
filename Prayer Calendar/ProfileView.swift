//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @Environment(DataHolder.self) var dataHolder
//    @Environment(\.modelContext) var modelContext
//    @Query var prayerRequests: [PrayerRequest]
    
    @State var username: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
                    Section {
                        VStack (spacing: 0) {
                            //To Fill in with Prayer Requests
                        }
                        .background(Color.gray.opacity(0.05))
                    } header: {
                        VStack {
                            Text("")
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        NavigationLink(destination: PrayerNameInputView(dataHolder: dataHolder)){
                                            Image(systemName: "list.bullet.rectangle")
                                        }
                                    }
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button(action: {
                                            self.signOut()
                                        }) {Text("logout")
                                                .bold()
                                                .font(.system(size: 14))
                                                .frame(width: 60, height: 25)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.blue)
                                                )
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            HStack {
                                Text("Logged in as: \(dataHolder.email)").padding(.leading, 20)
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
                                Button(action: {
                                    addPrayerRequest()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(.trailing, 15)
                            }
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func signOut() {
        // Sign out from firebase and change loggedIn to return to SignInView.
        try? Auth.auth().signOut()
        dataHolder.isLoggedIn = false
    }
                                       
    func addPrayerRequest() {
        let db = Firestore.firestore()
        let ref = db.collection("users").document("prayerRequests")
        
//        ref.setData(["email": dataHolder.email, "prayStartDate": prayStartDate, "prayerList": prayerList])
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(DataHolder())
    }
}
