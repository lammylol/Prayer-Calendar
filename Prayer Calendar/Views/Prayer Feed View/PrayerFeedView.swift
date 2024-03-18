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
    @State private var selectedPage: Int = 1
    
//    @State var pinnedPrayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedPage) {
                    if userHolder.pinnedPrayerRequests.isEmpty == false {
                        Text("Pinned").tag(0)
                    }
                    Text("Current").tag(1)
                    Text("Testimonies").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.top, 10)
                
                TabView(selection: $selectedPage) {
                    if userHolder.pinnedPrayerRequests.isEmpty == false {
                        PrayerFeedPinnedView(person: person, toggleView: "pinned").tag(0)
                    }
                    PrayerFeedCurrentView(person: person).tag(1)
                    PrayerFeedAnsweredView(person: person).tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .sheet(isPresented: $showSubmit, onDismiss: {
                }, content: {
                    SubmitPrayerRequestForm(person: person)
                })
                .task {
                    if userHolder.pinnedPrayerRequests.isEmpty {
                        selectedPage = 1
                    } else {
                        selectedPage = 1
                    }
                }
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
//            .task {
//                do { pinnedPrayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "pinned")
//                } catch {
//                    print("error retrieving prayerfeed")
//                }
//            }
            .navigationTitle("prayer feed")
            .navigationBarTitleDisplayMode(.automatic)
            .scrollIndicators(.hidden)
        }
    }
}

struct PrayerFeedAnsweredView: View {
    // view to only see 'answered' prayers
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
//    @State var size: CGSize = .zero
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    
    var body: some View {
        ScrollView{
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
                prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "answered")
            } catch {
                print("error retrieving prayerfeed")
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "answered")
                }
            }
        }, content: {
            PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .saveSize(in: $size)
    }
}

struct PrayerFeedCurrentView: View {
    // view to only see 'answered' prayers
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
//    var toggleView: String
    
    var body: some View {
        ScrollView{
            NavigationStack {
                ForEach(prayerRequests) { prayerRequest in
                    VStack{
                        NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                            PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                        }
                        Divider()
                    }
                }
            }
            .task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "current")
//                    if toggleView == "current" {
//                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "current")
//                    } else if toggleView == "answered" {
//                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "answered")
//                    } else { //if pinned
//                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "pinned")
//                    }
                } catch {
                    print("error retrieving prayerfeed")
                }
            }
            .sheet(isPresented: $showEdit, onDismiss: {
                Task {
                    do {
                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "current")
                    }
                }
            }, content: {
                PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .saveSize(in: $size)
    }
}

struct PrayerFeedPinnedView: View {
    // view to only see 'pinned' prayers
    @State private var showEdit: Bool = false
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    var toggleView: String
    
    var body: some View {
        ScrollView{
            NavigationStack {
                ForEach(prayerRequests) { prayerRequest in
                    VStack{
                        NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                            PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                        }
                        Divider()
                    }
                }
            }
            .task {
                prayerRequests = userHolder.pinnedPrayerRequests
            }
//            .task {
//                do {
//                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "pinned")
//                } catch {
//                    print("error retrieving prayerfeed")
//                }
//            }
            .sheet(isPresented: $showEdit, onDismiss: {
                Task {
                    do {
                        prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: "pinned")
                    }
                }
            }, content: {
                PrayerRequestFormView(person: userHolder.person, prayerRequest: prayerRequestVar)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}

#Preview {
    PrayerFeedView(person: Person(username: ""))
}
