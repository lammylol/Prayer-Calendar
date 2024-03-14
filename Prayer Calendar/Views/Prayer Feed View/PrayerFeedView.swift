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
    @State var size: CGSize = .zero
    
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
                .tabViewStyle(.page(indexDisplayMode: .never))
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
//        .saveSize(in: $size)
    }
}

struct PrayerFeedCurrentView: View {
    // view to only see 'answered' prayers
    @State private var showEdit: Bool = false
//    @State var size: CGSize = CGSize.zero
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    
    var body: some View {
        VStack{
            NavigationStack {
                List(prayerRequests, id: \.self) { prayerRequest in
//                    VStack{
                    ScrollView{
                        NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
                            PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button { PrayerRequestHelper().togglePinned(prayerRequest: prayerRequest) } label: {
                                if prayerRequest.isPinned == true {
                                                    Label("Pinned", systemImage: "envelope.open")
                                                } else {
                                                    Label("Unpinned", systemImage: "envelope.badge")
                                                }
                                            }
                        }
                        //                        Divider()
                        //                    }
                    }
                }
                .listStyle(.plain)
//                ForEach(prayerRequests) { prayerRequest in
//                    VStack{
//                        NavigationLink(destination: PrayerRequestFormView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName), prayerRequest: prayerRequest)) {
//                            PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
//                        }
////                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
////                            Button { PrayerRequestHelper().togglePinned(prayerRequest: prayerRequest) } label: {
////                                if prayerRequest.isPinned == true {
////                                                    Label("Pinned", systemImage: "envelope.open")
////                                                } else {
////                                                    Label("Unpinned", systemImage: "envelope.badge")
////                                                }
////                                            }
////                        }
//                        Divider()
//                    }
//                }
                    
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .saveSize(in: $size)
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
