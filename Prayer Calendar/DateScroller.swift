//
//  DateScroller.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/26/23.
//

import SwiftUI

struct DateScroller: View {
    
    @EnvironmentObject var dateHolder: DataHolder
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(action: previousMonth){
                Image(systemName: "arrow.left.circle.fill")
                    .imageScale(.small)
                    .font(Font.title)
                    .padding(.leading, 35)
            }
            Text(CalendarHelper().monthString(date: dateHolder.date) + " " + CalendarHelper().yearString(date: dateHolder.date))
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
//            Spacer()
            Button(action: nextMonth){
                Image(systemName: "arrow.right.circle.fill")
                    .imageScale(.small)
                    .font(Font.title)
                    .padding(.trailing, 35)
            }
            Spacer()
        }
        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
        
    }
    
    func previousMonth(){
        dateHolder.date = CalendarHelper().minusMonth(date: dateHolder.date)
    }
    
    func nextMonth(){
        dateHolder.date = CalendarHelper().plusMonth(date: dateHolder.date)
    }
    
    struct DateScroller_Previews: PreviewProvider {
        static var previews: some View {
            DateScroller()
                .environmentObject(DataHolder())
        }
    }
}

