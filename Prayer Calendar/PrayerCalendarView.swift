//
//  PrayerCalendarView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI
import SwiftData

struct PrayerCalendarView: View {
   
//    @Environment(\.modelContext) private var modelContext
//    @Query(sort: \UserPrayerProfile.prayStartDate, order: .forward)
//    var userProfile: [UserPrayerProfile]
//    
//    var user: UserPrayerProfile? { userProfile.first }
    @Environment(DataHolder.self) var dataHolder

    var body: some View {
        NavigationStack{        //Navigation Stack.
            ScrollView {        //ScrollView enables title to shrink.
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
                    Section {
                        VStack (spacing: 0) {
                            calendarGrid
                                .padding(.horizontal, 10)
                                .padding(.top, 20)
                        }
                        .background(Color.gray.opacity(0.05))
                    } header: { //Header that freezes for lazy stack.
                        VStack (spacing: 0) {
                            Text("")
                                .toolbar() {
                                    NavigationLink(destination: PrayerNameInputView()){
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
                        .background(Color.white)
                        .navigationTitle("Prayer Calendar")
                        .navigationBarTitleDisplayMode(.automatic)
                        .navigationBarBackButtonHidden(true)
                        .toolbarBackground(.white, for: .navigationBar)
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
                        let prayerRange =  CalendarHelper().rangeOfPrayerStart(startDate: dataHolder.prayStartDate, firstDayOfMonth: firstDayofMonth) + count - startingSpaces - 1
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, prayerStartingSpaces: prayerStartingSpaces, prayerList: dataHolder.prayerList, prayerRange: prayerRange)
                    }
                }
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
    }
}
