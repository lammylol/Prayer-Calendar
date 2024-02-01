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
    @State var person: PrayerPerson

    @State var prayerRequestVar: PrayerRequest = PrayerRequest.preview
    @State var prayerRequests = [PrayerRequest]()
    
    let db = Firestore.firestore()
    
    func handleTap(prayerRequest: PrayerRequest) async {
        prayerRequestVar = prayerRequest
    }
    
    var body: some View {
        
        LazyVStack {
    
            HStack {
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

                Button(action: { showSubmit.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .padding(.trailing, 15)
            }
                
            Divider()
            
            ForEach(prayerRequests) { prayerRequest in
                PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                    .onTapGesture {
                        Task {
                            await handleTap(prayerRequest: prayerRequest)
                        }
                        self.showEdit.toggle()
                    }
            }
        }
        
        .overlay {
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
        
        .task {
            do {
                person = await PrayerPersonHelper().retrieveUserInfoFromUsername(person: person, userHolder: userHolder)
                prayerRequests = try await PrayerRequestHelper().retrievePrayerRequest(userID: person.userID, person: person)
                print("Success retrieving prayer requests for \(person.userID)")
                print(prayerRequests)
            } catch PrayerRequestRetrievalError.noUserID {
                print("No User ID to retrieve prayer requests with.")
            } catch {
                print("Error retrieving prayer requests.")
            }
        }
        
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerRequestHelper().retrievePrayerRequest(userID: person.userID, person: person)
                    print("Success retrieving prayer requests for \(person.userID)")
                    print(prayerRequests)
                } catch PrayerRequestRetrievalError.noUserID {
                    print("No User ID to retrieve prayer requests with.")
                } catch {
                    print("Error retrieving prayer requests.")
                }
            }
        }, content: {
            EditPrayerRequestForm(person: person, prayerRequest: prayerRequestVar)
        })
        
        .sheet(isPresented: $showSubmit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerRequestHelper().retrievePrayerRequest(userID: person.userID, person: person)
                    print("Success retrieving prayer requests for \(person.userID)")
                    print(prayerRequests)
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
    PrayerRequestsView(person: PrayerPerson(userID: "aMq0YdteGEbYXWlSgxehVy7Fyrl2", username: "lammylol"))
}
