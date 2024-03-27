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

    @State private var selectedTab: Tab? = .current
    @State private var tabProgress: CGFloat = 0
    
//    @State var pinnedPrayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.colorScheme) private var scheme
    
    var person: Person

    var body: some View {
        NavigationStack {
//            ScrollView(.vertical) {
                VStack {
                    //Custom Tab Bar
                    CustomTabBar()
                    //                PrayerFeedCurrentView(person: person)
                    
                    // Paging View
                    GeometryReader {
                        let size = $0.size
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                if userHolder.pinnedPrayerRequests.isEmpty == false {
                                    PrayerFeedPinnedView(person: person)
                                        .containerRelativeFrame(.horizontal)
                                        .id(Tab.pinned)
                                }
                                PrayerFeedCurrentView(person: person)
                                    .containerRelativeFrame(.horizontal)
                                    .id(Tab.current)
                                PrayerFeedAnsweredView(person: person)
                                    .containerRelativeFrame(.horizontal)
                                    .id(Tab.answered)
                            }
                            .offsetX { value in
                                let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                                tabProgress = max(min(progress, 1), 0)
                            }
                        }
                        .scrollPosition(id: $selectedTab)
                        .scrollTargetBehavior(.paging)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationTitle("prayer feed")
//                .frame(height: 500)
//            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        @State var array = [Tab.Type]()
        
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    //Updating Tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
//        .task {
//            if userHolder.pinnedPrayerRequests.isEmpty == false {
//                ForEach(Tab.AllCases) { case in
//                    array.append(case)
//                }
//            }
//        }
        .tabMask(tabProgress)
        // Scrollable Active Tab Indicator
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    
//        NavigationStack {
//            TabView(selection: $selectedPage) {
//                if userHolder.pinnedPrayerRequests.isEmpty == false {
//                    PrayerFeedPinnedView(person: person, selectedPage: $selectedPage)
//                        .tag(0)
//                }
//                PrayerFeedCurrentView(person: person, selectedPage: $selectedPage)
//                    .tag(1)
//                PrayerFeedAnsweredView(person: person, selectedPage: $selectedPage)
//                    .tag(2)
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .navigationTitle("Prayer Feed")
//            .navigationBarTitleDisplayMode(.automatic)
//        }
//            
//        NavigationStack {
//            ScrollView {
//                VStack {
//                    Picker("", selection: $selectedPage) {
//                        if userHolder.pinnedPrayerRequests.isEmpty == false {
//                            Text("Pinned").tag(0)
//                        }
//                        Text("Current").tag(1)
//                        Text("Testimonies").tag(2)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding(.top, 10)
//                    
//                    TabView(selection: $selectedPage) {
//                        if userHolder.pinnedPrayerRequests.isEmpty == false {
//                            PrayerFeedPinnedView(person: person)
////                            FeedRequestsRowView(person: person, answeredFilter: "pinned")
//                                .fixedSize(horizontal: false, vertical: true)
//                                .getSizeOfView(getHeight: { size in
//                                    sizeArray[0] = size
//                                })
//                                .tag(0)
////                                .getSizeOfView {
////                                    height = $0
////                                }
//                        }
////                        FeedRequestsRowView(person: person, answeredFilter: "current")
//                        PrayerFeedCurrentView(person: person)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .getSizeOfView(getHeight: { size in
//                                sizeArray[1] = size
//                                if initialHeight == 0 {
//                                    initialHeight = size.height
//                                }
//                            })
//                            .tag(1)
////                            .getSizeOfView {
////                                height = $0
////                            }
//                        
//                        PrayerFeedAnsweredView(person: person)
////                        FeedRequestsRowView(person: person, answeredFilter: "answered")
//                            .fixedSize(horizontal: false, vertical: true)
//                            .getSizeOfView(getHeight: { size in
//                                sizeArray[2] = size
//                            })
//                            .tag(2)
////                            .getSizeOfView {
////                                height = $0
////                            }
//                    }
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                    .frame(height: height)
//                    .frame(maxWidth: .infinity)
//                    .sheet(isPresented: $showSubmit, onDismiss: {
//                    }, content: {
//                        SubmitPrayerRequestForm(person: person)
//                    })
//                    .onChange(of: selectedPage) {
//                        height = sizeArray[selectedPage].height
//                    }
//                    .onChange(of: initialHeight) { oldValue, newValue in
//                        height = newValue
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: { showSubmit.toggle()
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                    .padding(.trailing, 15)
//                }
//            }
//            .navigationTitle("prayer feed")
//            .navigationBarTitleDisplayMode(.automatic)
//            .scrollIndicators(.hidden)
////            .scrollTargetBehavior(.paging)
////            .scrollTargetLayout()
//        }
}

struct FeedRequestsRowView: View {
    @State private var showEdit: Bool = false
//    @Binding var height: CGFloat
    
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    var person: Person
    var answeredFilter: String
//    @Binding var selectedPage: Int
    
    
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
    }
}

struct PrayerFeedAnsweredView: View {
    // view to only see 'answered' prayers
    var person: Person
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
    
//    @Binding var height: CGFloat
    
    var body: some View {
        ScrollView {
            FeedRequestsRowView(person: person, answeredFilter: "answered")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerFeedCurrentView: View {
    // view to see 'current' prayers
    var person: Person
//    @Binding var height: CGFloat
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
//
    var body: some View {
        ScrollView {
            FeedRequestsRowView(person: person, answeredFilter: "current")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PrayerFeedPinnedView: View {
    // view to only see 'pinned' prayers
    var person: Person
//    @Binding var height: CGFloat
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
    
    var body: some View {
        ScrollView {
            FeedRequestsRowView(person: person, answeredFilter: "pinned")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}
//
//#Preview {
//    PrayerFeedView(person: Person(username: ""))
//}
