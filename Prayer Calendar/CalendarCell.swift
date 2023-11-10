//
//  CalendarCell.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 9/26/23.
//

import Foundation
import SwiftUI

struct CalendarCell: View {
    @Environment(\.colorScheme) var colorScheme
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    let prayerStartingSpaces: Int
    let prayerList: String
    let prayerListArray: [String]
    let prayerRange: Int
    
    init(count: Int, startingSpaces: Int, daysInMonth: Int, daysInPrevMonth: Int, prayerStartingSpaces: Int, prayerList: String, prayerRange: Int) {
        self.count = count
        self.startingSpaces = startingSpaces
        self.daysInMonth = daysInMonth
        self.daysInPrevMonth = daysInPrevMonth
        self.prayerStartingSpaces = prayerStartingSpaces
        self.prayerList = prayerList
        self.prayerListArray = prayerList.split(separator: "\n").map(String.init)
        self.prayerRange = prayerRange
    }
    
    var body: some View {
        VStack {
            Text(monthStruct().day())
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(textColor(type: monthStruct().monthType))
            Spacer()
            Text(monthStruct().prayerName)
                .font(Font.system(size: 12))
            Spacer()
        }
            .frame(maxWidth: .infinity)
            .frame(height: 95)
    }
    
    func textColor(type: MonthType) -> Color {
        if type == MonthType.Current {
            if colorScheme == .light {
                return Color.black
            } else {
                return Color.white
            }
        } else {
            return Color.gray
        }
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces // == 0 ? startingSpaces + 7: startingSpaces
//        let prayerStart = prayerStartingSpaces == 0 ? prayerStartingSpaces + 7: prayerStartingSpaces
        
        if (count <= start) {
            let day = daysInPrevMonth - (startingSpaces - count)
            let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerListArray: prayerListArray)
            return MonthStruct(monthType: MonthType.Previous, dayInt: day, prayerName: name, prayerRange: prayerRange)
        }
        
        else if ((count - startingSpaces) > daysInMonth) {
            let day = count - startingSpaces - daysInMonth
            let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerListArray: prayerListArray)
            return MonthStruct(monthType: MonthType.Next, dayInt: day, prayerName: name, prayerRange: prayerRange)
        }
        
        let day = count-start
        let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerListArray: prayerListArray)
        return MonthStruct(monthType: MonthType.Current, dayInt: day, prayerName: name, prayerRange: prayerRange)
    }
    
    func prayerNameFunc(count: Int, prayerRange: Int, prayerListArray: [String]) -> String {
        if prayerRange < 0 || prayerListArray.isEmpty { //(count - startingSpaces) + prayerRange <= 0) ||
            return ""
        }
        return prayerListArray[prayerRange % prayerListArray.count]
    }
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
       CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, prayerStartingSpaces: 1, prayerList: "Matt", prayerRange: 1)
    }
}
