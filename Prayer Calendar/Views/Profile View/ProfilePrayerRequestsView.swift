//
//  PrayerRequestsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

// This is the view to capture the list of prayer requests.

import SwiftUI
import FirebaseFirestore

struct ProfilePrayerRequestsView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @State var viewModel: PrayerRequestViewModel = PrayerRequestViewModel()
    
    @State var person: Person
    @State private var showSubmit: Bool = false
    @State private var showEdit: Bool = false
    @State private var height: CGFloat = 0
    
    let db = Firestore.firestore()
    
    var body: some View {
        LazyVStack {
            HStack{
                // Only show this if you are the owner of profile.
                if person.username == userHolder.person.username {
                    Text("My Prayer Requests")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                } else {
                    Text("\(person.firstName)'s Prayer Requests")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                // Only show this if the account has been created under your userID. Aka, can be your profile or another that you have created for someone.
                if person.userID == userHolder.person.userID {
                    Button(action: { showSubmit.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.trailing, 15)
                }
            }
                
            Divider()
            
            FeedRequestsRowView(viewModel: viewModel, height: $height, person: person, profileOrFeed: "profile")
        }
        .overlay {
            // Only show this if this account is saved under your userID.
            if person.userID == userHolder.person.userID {
                if viewModel.prayerRequests.isEmpty {
                    VStack{
                        ContentUnavailableView {
                            Label("No Prayer Requests", systemImage: "list.bullet.rectangle.portrait")
                        } description: {
                            Text("Start adding prayer requests to your list")
                        } actions: {
                            Button(action: {showSubmit.toggle() })
                            {
                                Text("Add Prayer Request")
                            }
                        }
                        .frame(height: 250)
                        .offset(y: 120)
                        Spacer()
                    }
                }
            }
        }
        .task {
            do {
                viewModel.selectedStatus = .none
//                        await viewModel.getPrayerRequests(user: userHolder.person, person: person, profileOrFeed: "profile")
                print("Success retrieving prayer requests for \(person.userID)")
            } catch PrayerRequestRetrievalError.noUserID {
                print("No User ID to retrieve prayer requests with.")
            } catch {
                print("Error retrieving prayer requests.")
            }
        }
//        .sheet(isPresented: $showEdit, onDismiss: {
//            Task {
//                do {
//                    if viewModel.prayerRequests.isEmpty {
//                        await viewModel.getPrayerRequests(user: userHolder.person, person: person, profileOrFeed: "profile")
//                    } else {
//                        self.viewModel.prayerRequests = viewModel.prayerRequests
//                        self.height = height
//                    }
//                    print("Success retrieving prayer requests for \(person.userID)")
//                }
//            }
//        }, content: {
//                PrayerRequestFormView(person: person, prayerRequest: $prayerRequestVar)
//        })
        .sheet(isPresented: $showSubmit, onDismiss: {
            Task {
                do {
                    if viewModel.prayerRequests.isEmpty {
                        await viewModel.getPrayerRequests(user: userHolder.person, person: person, profileOrFeed: "profile")
                    } else {
                        self.viewModel.prayerRequests = viewModel.prayerRequests
                        self.height = height
                    }
                    print("Success retrieving prayer requests for \(person.userID)")
                }
            }
        }, content: {
            SubmitPrayerRequestForm(person: person)
        })
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ProfilePrayerRequestsView(person: Person(userID: "aMq0YdteGEbYXWlSgxehVy7Fyrl2", username: "lammylol"))
}
