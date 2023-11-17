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
//    @State var prayerRequests: [PrayerRequest] = []
    @State private var showView: Bool = false
    @State var username: String
    
    @Environment(PrayerList.self) var dataHolder
    @Environment(PrayerRequestViewModel.self) var viewModel
    
//    init(dataHolder: PrayerList) {
//        self.dataHolder = dataHolder
//    }
    
    var body: some View {
        NavigationStack {
            //                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
            ScrollView {
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
                    Button(action: { showView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.trailing, 15)
                }
                    
                Divider()
                
                PrayerRequestsView(username: username)
                }
//                .padding([.leading, .trailing], 20)
//                .padding([.top, .bottom], 20)
                .frame(height: 1000)
                .sheet(isPresented: $showView) {
                    SubmitPrayerRequestForm()
                }
                
                Spacer()
            }
        }
        .navigationTitle("profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func signOut() {
        // Sign out from firebase and change loggedIn to return to SignInView.
        try? Auth.auth().signOut()
        dataHolder.prayerList = ""
        dataHolder.isLoggedIn = false
    }
                    
    func resetInfo() {
        dataHolder.prayerList = ""
        dataHolder.prayStartDate = Date()
    }
}

#Preview {
    ProfileView(username: "matthewthelam@gmail.com")
        .environment(PrayerList())
        .environment(PrayerRequestViewModel())
}
