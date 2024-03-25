//
//  PrayerRequestsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

// This is the view to capture the list of prayer requests.

import SwiftUI
import FirebaseFirestore

struct PrayerRequestsView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @State private var showSubmit: Bool = false
    @State private var showEdit: Bool = false
    @State var person: Person

    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    @State var prayerRequests = [PrayerRequest]()
    
    let db = Firestore.firestore()
    
    func handleTap(prayerRequest: PrayerRequest) async {
        prayerRequestVar = prayerRequest
    }
    
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
            
            NavigationStack {
                ForEach($prayerRequests) { prayerRequest in
                    VStack{
//                        NavigationLink(destination: PrayerRequestFormView(person: person, prayerRequest: prayerRequest)) {
                        PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "profile")
//                        }
                        Divider()
                    }
                }
            }
        }
        .overlay {
            // Only show this if this account is saved under your userID.
            if person.userID == userHolder.person.userID {
                if prayerRequests.isEmpty {
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
                person = await PrayerPersonHelper().retrieveUserInfoFromUsername(person: person, userHolder: userHolder)
                prayerRequests = try await PrayerRequestHelper().getPrayerRequests(userID: person.userID, person: person)
                print("Success retrieving prayer requests for \(person.userID)")
            } catch PrayerRequestRetrievalError.noUserID {
                print("No User ID to retrieve prayer requests with.")
            } catch {
                print("Error retrieving prayer requests.")
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerRequestHelper().getPrayerRequests(userID: person.userID, person: person)
                    print("Success retrieving prayer requests for \(person.userID)")
                } catch PrayerRequestRetrievalError.noUserID {
                    print("No User ID to retrieve prayer requests with.")
                } catch {
                    print("Error retrieving prayer requests.")
                }
            }
        }, content: {
                PrayerRequestFormView(person: person, prayerRequest: $prayerRequestVar)
        })
        .sheet(isPresented: $showSubmit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerRequestHelper().getPrayerRequests(userID: person.userID, person: person)
                    print("Success retrieving prayer requests for \(person.userID)")
                } catch PrayerRequestRetrievalError.noUserID {
                    print("No User ID to retrieve prayer requests with.")
                } catch {
                    print("Error retrieving prayer requests.")
                }
            }
        }, content: {
            SubmitPrayerRequestForm(person: person)
        })
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PrayerRequestsView(person: Person(userID: "aMq0YdteGEbYXWlSgxehVy7Fyrl2", username: "lammylol"))
}
