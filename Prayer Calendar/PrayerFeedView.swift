//
//  PrayerFeedView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/2/24.
//

import SwiftUI

struct PrayerFeedView: View {
    @State private var showSubmit: Bool = false
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    
    func handleTap(prayerRequest: PrayerRequest) async {
        prayerRequestVar = prayerRequest
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: { showSubmit.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                                .padding(.trailing, 15)
                            }
                        }
                    Spacer()
                    ForEach(prayerRequests) { prayerRequest in
                        NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                            PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                        }
                        Divider()
                    }
                }
                .task {
                    do {
                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID)
                    } catch {
                        print("error retrieving prayerfeed")
                    }
                }
            }
            .navigationTitle("prayer feed")
            .navigationBarTitleDisplayMode(.automatic)
            .sheet(isPresented: $showSubmit, onDismiss: {
            }, content: {
                SubmitPrayerRequestForm(person: person)
            })
            .sheet(isPresented: $showEdit, onDismiss: {
                Task {
                    do {
                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID)
                    }
                }
            }, content: {
                PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
            })
        }

    }
}

#Preview {
    PrayerFeedView(person: Person(username: ""))
}
