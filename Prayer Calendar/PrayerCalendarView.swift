//
//  PrayerCalendarView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI
import SwiftData
import FirebaseFirestore
import FirebaseCore

struct PrayerCalendarView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var dataHolder
    @Environment(\.colorScheme) var colorScheme
//    @Bindable var dataHolder: DataHolder
    
//    init(dataHolder: DataHolder) {
//        self.dataHolder = dataHolder
////        _email = State(initialValue: dataHolder.email)
//        _prayerList = State(initialValue: dataHolder.prayerList)
//        _prayStartDate = State(initialValue: dataHolder.prayStartDate)
//    }
    
    var body: some View {
        NavigationStack{        //Navigation Stack.
            ScrollView {        //ScrollView enables title to shrink.
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
                    Section {
                        VStack (spacing: 0) {
                            calendarGrid
                                .padding(.horizontal, 10)
                                .padding(.top, 20)
                                .task {
                                    await getFirestoreData()
                                }
                        }
                        .background(Color.gray.opacity(0.05))
                    } header: { //Header that freezes for lazy stack.
                        VStack (spacing: 0) {
                            Text("")
                                .toolbar() {
                                    NavigationLink(destination: PrayerNameInputView(dataHolder: dataHolder)){
                                        Image(systemName: "list.bullet.rectangle")
                                    }
                                }
                            DateScroller()
                                .padding([.top, .bottom], 0)
                            Spacer()
                            dayOfWeekStack
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .padding([.top], 10)
                        }
                        .padding([.top, .bottom], 10)
                        .background(UIHelper().backgroundColor(colorScheme: colorScheme))
                        .navigationTitle("prayer calendar")
                        .navigationBarTitleDisplayMode(.automatic)
                        .navigationBarBackButtonHidden(true)
                        .toolbarBackground(UIHelper().backgroundColor(colorScheme: colorScheme), for: .navigationBar)
                    }
                }
        }
        }
    }
    
    var dayOfWeekStack: some View {
        HStack(
            spacing: 1
        ){
            Text("S").dayOfWeek()
            Text("M").dayOfWeek()
            Text("T").dayOfWeek()
            Text("W").dayOfWeek()
            Text("T").dayOfWeek()
            Text("F").dayOfWeek()
            Text("S").dayOfWeek()
        }
        .font(Font.system(size: 12))
        .fontWeight(.semibold)
    }
    
    var calendarGrid: some View {
        VStack() {
//            prayerList = dataHolder.prayerList //Required so that view will reset when prayerList changes.
            let firstDayofMonth = CalendarHelper().firstDayOfMonth(date: dataHolder.date) //First Day of the Month
            let startingSpaces = CalendarHelper().weekDay(date: firstDayofMonth)-1 //Number of spaces before month starts in a table of 42 rows.
            let daysInMonth = CalendarHelper().daysInMonth(date: dataHolder.date) //Number of days in each month.
            let daysInPrevMonth = CalendarHelper().daysInMonth(date: CalendarHelper().minusMonth(date: dataHolder.date))
            
            let prayerStartingSpaces = CalendarHelper().weekDay(date: dataHolder.prayStartDate) //Number of spaces before prayer start date begins in a table of 42 rows.
            
            ForEach(0..<5){ row in
                HStack(spacing: 1)
                {
                    ForEach(1..<8)
                    { column in
                        let count = column + (row * 7)
                        let prayerRange =
                        CalendarHelper().rangeOfPrayerStart(startDate: dataHolder.prayStartDate, firstDayOfMonth: firstDayofMonth) + count - startingSpaces - 1
                        
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, prayerStartingSpaces: prayerStartingSpaces, prayerList: dataHolder.prayerList, prayerRange: prayerRange)
                    }
                }
            }
        }
    }
    
    //This function retrieves PrayerList data from Firestore.
    func getFirestoreData() async {
            let ref = Firestore.firestore()
                .collection("users")
                .document(userHolder.person.username).collection("prayerList").document("prayerList1")
            
            ref.getDocument{(document, error) in
                if let document = document, document.exists {
                    
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: " + dataDescription)
                        
                        //Update Dataholder with PrayStartDate from Firestore
                        let startDateTimeStamp = document.get("prayStartDate") as! Timestamp
                        dataHolder.prayStartDate = startDateTimeStamp.dateValue()
                        
                        
                        //Update Dataholder with PrayerList from Firestore
                        dataHolder.prayerList = document.get("prayerList") as! String
                    
                } else {
                    print("Document does not exist")
                    dataHolder.prayerList = ""
                }
            }
    }
}

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding([.top], 1)
            .lineLimit(1)
    } // Sets dayOfWeek width and padding.
}

struct PrayerCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCalendarView()
            .environment(UserProfileHolder())
            .environment(PrayerListHolder())
    }
}
