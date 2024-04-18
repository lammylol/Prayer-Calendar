//
//  PrayerFeedView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/2/24.
//

import SwiftUI
import FirebaseFirestore

struct PrayerFeedView: View {
    @State private var showSubmit: Bool = false
    @State private var showEdit: Bool = false
    @State private var selectedPage: Int = 1

//    @State private var selectedTab: Tab? = Tab.current
    @State private var selectedTab: Int = 1
    @State private var tabProgress: CGFloat = 0
    @State private var height: CGFloat = 0
    @State private var sizeArray: [CGFloat] = [.zero, .zero, .zero]
    
//    @State var pinnedPrayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.colorScheme) private var scheme
    
    var person: Person

    var body: some View {
        NavigationStack {
            PrayerFeedCurrentView(person: person, height: $height)
                .containerRelativeFrame(.horizontal)
                .tag(1)
//            ScrollView(.vertical) {
//                // title hides when you scroll down
//                HStack {
//                    Text("prayer feed")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding(.leading, 16)
//                    Spacer()
//                }
//                .offset(y: 15)
//                .padding(.top, 27)
//                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
//                    // Pinned section
//                    Section( header:
//                        //Custom Tab Bar
//                             CustomTabBarNew(selectedTab: $selectedTab, pinned: userHolder.pinnedPrayerRequests)
//                        .background(
//                            scheme == .dark ? .black : .white
//                        )
//                    ) {
//                        VStack {
//                            // Paging View
//                            PrayerFeedCurrentView(person: person, height: $height)
//                                .containerRelativeFrame(.horizontal)
//                                .tag(1)
////                            GeometryReader { geo in
////                                TabView(selection: $selectedTab) {
////                                    if userHolder.pinnedPrayerRequests.isEmpty == false {
////                                        PrayerFeedPinnedView(person: person, height: $height)
////                                            .containerRelativeFrame(.horizontal)
////                                            .tag(0)
////                                    }
////                                    PrayerFeedCurrentView(person: person, height: $height)
////                                        .containerRelativeFrame(.horizontal)
////                                        .tag(1)
////                                    PrayerFeedAnsweredView(person: person, height: $height)
////                                        .containerRelativeFrame(.horizontal)
////                                        .tag(2)
////                                }
////                                .tabViewStyle(.page(indexDisplayMode: .never))
////                                    
////                                ScrollView(.horizontal) {
////                                    HStack(spacing: 0) {
////                                        if userHolder.pinnedPrayerRequests.isEmpty == false {
////                                            PrayerFeedPinnedView(person: person, height: $height)
////                                                .containerRelativeFrame(.horizontal)
////                                                .id(Tab.pinned)
////                                        }
////                                        PrayerFeedCurrentView(person: person, height: $height)
////                                            .containerRelativeFrame(.horizontal)
////                                            .id(Tab.current)
////                                        PrayerFeedAnsweredView(person: person, height: $height)
////                                            .containerRelativeFrame(.horizontal)
////                                            .id(Tab.answered)
////                                    }
////                                    .offsetX { value in
////                                        if userHolder.pinnedPrayerRequests.isEmpty == false {
////                                            let progress = -value / (size.width * CGFloat(3 - 1))
////                                            tabProgress = max(min(progress, 1), 0)
////                                        } else {
////                                            let progress = -value / (size.width * CGFloat(2 - 1))
////                                            tabProgress = max(min(progress, 1), 0)
////                                        }
////                                    }
////                                }
////                                .scrollPosition(id: $selectedTab)
////                                .scrollTargetBehavior(.paging)
//                                //                        .onChange(of: selectedTab) {
//                                //                            self.height = height
//                                //                        }
//                                //
////                            }
///*                            .frame(minHeight: height, alignment: .top)*/ // necessary to hold frame while in GeometryReader and ScrollView
//                        }
//                        //                .frame(height: height)
//                        //                .fixedSize(horizontal: false, vertical: true)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                }
//            }
//            .clipped()
        }
    }
}

struct FeedRequestsRowView: View {
    @State private var showEdit: Bool = false
    @State var prayerRequests: [PrayerRequest] = []
    @State var prayerRequestVar: PrayerRequest = PrayerRequest.blank
    
    @Environment(PrayerRequestViewModel.self) var viewModel
//    @State var viewModel: PrayerRequestViewModel = PrayerRequestViewModel()
    @Environment(UserProfileHolder.self) var userHolder
    
    var person: Person
    var answeredFilter: String
    
    var body: some View {
//        @Bindable var viewModel = viewModel // to enable binding for it.
        
        NavigationStack {
            ForEach(viewModel.prayerRequests) { prayerRequest in
                LazyVStack {
                    PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
                    Divider()
                }
                if prayerRequest.id == viewModel.prayerRequests.last?.id {
                    ProgressView()
                        .onAppear {
                            viewModel.getPrayerRequests(person: person)
                        }
                }
            }
//            List {
//                ForEach(viewModel.prayerRequests) { prayerRequest in
//                    LazyVStack {
//                        PrayerRequestRow(prayerRequest: prayerRequest, profileOrPrayerFeed: "feed")
//                        Divider()
//                        if prayerRequest.id == viewModel.prayerRequests.last?.id {
//                            ProgressView()
//                                .onAppear {
//                                    viewModel.getPrayerRequests(person: person)
//                                }
//                        }
//                    }
//                }
//            }
//            .scrollDismissesKeyboard(.immediately)
//            .scrollContentBackground(.hidden)
//            .listStyle(.plain)
        }
//        .environment(viewModel)
        .task {
            viewModel.getPrayerRequests(person: person)
            print(viewModel.prayerRequests.description)
        }
        .sheet(isPresented: $showEdit, onDismiss: {
            Task {
                do {
                    viewModel.getPrayerRequests(person: person)
//                    prayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: person.userID, answeredFilter: answeredFilter)
                }
            }
        }, content: {
            PrayerRequestFormView(person: userHolder.person, prayerRequest: $prayerRequestVar)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct PrayerFeedAnsweredView: View {
    // view to only see 'answered' prayers
    var person: Person
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
    
    @Binding var height: CGFloat
    
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "answered")
        .getSizeOfView(completion: {
            height = $0
        })
    }
}

struct PrayerFeedCurrentView: View {
    // view to see 'current' prayers
    var person: Person
    @Binding var height: CGFloat
    
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerRequestViewModel.self) var viewModel
//
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "current")
        .getSizeOfView(completion: {
            height = $0
        })
//        .task {
//            do { 
//                try await viewModel.statusFilter(option: .current, person: person)
//            } catch {
//                print(error)
//            }
//        }
    }
}

struct PrayerFeedPinnedView: View {
    // view to only see 'pinned' prayers
    var person: Person
    @Binding var height: CGFloat
    
//    @Binding var selectedPage: Int
    @Environment(UserProfileHolder.self) var userHolder
    
    var body: some View {
        FeedRequestsRowView(person: person, answeredFilter: "pinned")
        .getSizeOfView(completion: {
            height = $0
        })
    }
}

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HeightKey: PreferenceKey {
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
    func getSizeOfView(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: HeightKey.self, value: geo.size.height)
                        .onPreferenceChange(HeightKey.self, perform: completion)
                        .onAppear { print(geo.size.height) }
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat, tabs: [Tab]) -> some View {
        
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(tabs.count)
                        
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
