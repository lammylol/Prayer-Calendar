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
    @State private var selectedPage: Int = 0
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    @State var viewPagerSize: CGSize = .zero
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedPage) {
                    Text("Current").tag(0)
                    Text("Testimonies").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.top, 10)
                
                TabView(selection: $selectedPage) {
                    PrayerFeedCurrentView(person: person).tag(0)
                    PrayerFeedAnsweredView(person: person).tag(1)
                }
                .tabViewStyle(.page)
                .sheet(isPresented: $showSubmit, onDismiss: {
                }, content: {
                    SubmitPrayerRequestForm(person: person)
                })
            }
                
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showSubmit.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .padding(.trailing, 15)
                    }
                }
                .navigationTitle("prayer feed")
                .navigationBarTitleDisplayMode(.automatic)
        }
//                VStack {
//                    //                    Picker("", selection: $selectedPage) {
//                    //                        Text("Current").tag(0)
//                    //                        Text("Answered").tag(1)
//                    //                    }
//                    //                    .pickerStyle(.segmented)
//                    //                    .padding([.top, .bottom], 10)
//                    //
//                    TabView(selection: $selectedPage) {
//                        PrayerFeedCurrentView(person: person).tag(0)
//                            .frame(maxHeight: .infinity)
//                        PrayerFeedAnsweredView(person: person).tag(1)
//                            .frame(maxHeight: .infinity)
//                    }
//                    .frame(maxHeight: .infinity)
//                    .tabViewStyle(.page)
//                    .border(.clear) // need to check if this does anything. Hide borders.
//                }
    }
}

struct PrayerFeedAnsweredView: View {
    // view to only see 'answered' prayers
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    
    var body: some View {
        ScrollView {
            NavigationStack{
                ForEach(prayerRequests) { prayerRequest in
                    NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                        PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                    }
                    Divider()
                }
            }
        }
        .task {
            do {
                prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: true)
            } catch {
                print("error retrieving prayerfeed")
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: true)
                }
            }
        }, content: {
            PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
        })
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerFeedCurrentView: View {
    // view to only see 'answered' prayers
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    
    var body: some View {
        ScrollView {
            NavigationStack{
                ForEach(prayerRequests) { prayerRequest in
                    NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                        PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                    }
                    Divider()
                }
            }
        }
        .task {
            do {
                prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: false)
            } catch {
                print("error retrieving prayerfeed")
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: false)
                }
            }
        }, content: {
            PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PrayerFeedView(person: Person(username: ""))
}
