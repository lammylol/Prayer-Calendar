//
//  PrayerCalendarView.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/25/23.
//

import SwiftUI

struct PrayerCalendarView: View {
   
    @EnvironmentObject var dataHolder: DataHolder

    var dateDictionary: [Date: [String]] = [:]
    var dayOfMonth = Date()

    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        VStack (spacing: 0) {
                            calendarGrid
                                .padding(.horizontal, 10)
                                .padding(.top, 20)
                        }
                        .background(Color.gray.opacity(0.05))
                    } header: {
                        VStack (spacing: 0) {
                            Text("")
                                .toolbar() {
                                    NavigationLink(destination: PrayerNameInputView(inputList: dataHolder.prayerListString, prayStartDate: dataHolder.prayStartDate)){
                                        Image(systemName: "list.bullet.rectangle")
                                    }
                                }
                            DateScroller()
                                .environmentObject(dataHolder)
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

            let firstDayofMonth = CalendarHelper().firstDayOfMonth(date: dataHolder.date)
            let startingSpaces = CalendarHelper().weekDay(date: firstDayofMonth)-1
            let prayerStartingSpaces = CalendarHelper().weekDay(date: dataHolder.prayStartDate)
            let daysInMonth = CalendarHelper().daysInMonth(date: dataHolder.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(date: CalendarHelper().minusMonth(date: dataHolder.date))
            
            ForEach(0..<5){ row in
                HStack(spacing: 1)
                {
                    ForEach(1..<8)
                    { column in
                        let count = column + (row * 7)
                        let prayerRange =  CalendarHelper().rangeOfPrayerStart(startDate: dataHolder.prayStartDate, firstDayOfMonth: firstDayofMonth) + count - startingSpaces - 1
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth, prayerStartingSpaces: prayerStartingSpaces, prayerList: dataHolder.prayerList, prayerRange: prayerRange)
                            .environmentObject(dataHolder)
                    }
                }
            }
        }
        
    }
}

struct PrayerCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerCalendarView()
            .environmentObject(DataHolder())
    }
}

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .padding([.top], 1)
            .lineLimit(1)
    }
}
