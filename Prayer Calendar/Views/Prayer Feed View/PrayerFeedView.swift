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
    @State private var height: CGFloat = 500

    var body: some View {
        NavigationStack {
            ScrollView {
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
                            PrayerFeedPinnedView(person: person)
                                .tag(0)
                                .getSizeOfView {
                                    height = $0
                                }
                        }
                        PrayerFeedCurrentView(person: person)
                            .tag(1)
                            .getSizeOfView {
                                height = $0
                            }
                        PrayerFeedAnsweredView(person: person)
                            .tag(2)
                            .getSizeOfView {
                                height = $0
                            }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(idealHeight: height)
                    .sheet(isPresented: $showSubmit, onDismiss: {
                    }, content: {
                        SubmitPrayerRequestForm(person: person)
                    })
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
            .navigationTitle("prayer feed")
            .navigationBarTitleDisplayMode(.automatic)
            .scrollIndicators(.hidden)
//            .scrollTargetBehavior(.paging)
//            .scrollTargetLayout()
        }
    }
}

struct FeedRequestsRowView: View {
    @State private var showEdit: Bool = false
//    @Binding var height: CGFloat
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    var answeredFilter: String
    
    var body: some View {
        LazyVStack {
            NavigationStack {
                ForEach($prayerRequests) { prayerRequest in
                    LazyVStack {
                        PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                        Divider()
                    }
                }
            }
        }
        .task {
            do {
                prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: answeredFilter)
            } catch {
                print("error retrieving prayerfeed")
            }
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: answeredFilter)
                }
            }
        }, content: {
            PrayerRequestFormView(person: userHolder.person, prayerRequest: $prayerRequestVar)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .getSizeOfView {
//            self.height = $0
//            print(height)
//        }
    }
}

struct PrayerFeedAnsweredView: View {
    // view to only see 'answered' prayers
    var person: Person
//    @Binding var height: CGFloat
    
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "answered")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerFeedCurrentView: View {
    // view to see 'current' prayers
    var person: Person
//    @Binding var height: CGFloat
//    
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "current")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerFeedPinnedView: View {
    // view to only see 'pinned' prayers
    var person: Person
//    @Binding var height: CGFloat
    
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "pinned")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func getSizeOfView(_ getHeight: @escaping (CGFloat) -> ()) -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size.height
                    )
                    .onPreferenceChange(SizePreferenceKey.self) { value in
                        getHeight(value)
                    }
                }
            }
    }
}

#Preview {
    PrayerFeedView(person: Person(username: ""))
}
