//
//  CalendarCell.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 9/26/23.
//

import Foundation
import SwiftUI

struct CalendarCell: View {
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    let prayerStartingSpaces: Int
    let prayerList: [String]
    let prayerRange: Int
    
    var body: some View {
        VStack {
            Text(monthStruct().day())
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(textColor(type: monthStruct().monthType))
            Spacer()
            Text(monthStruct().prayerName)
                .font(Font.system(size: 12))
//                .padding(.top, 40)
            Spacer()
        }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.black: Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces // == 0 ? startingSpaces + 7: startingSpaces
//        let prayerStart = prayerStartingSpaces == 0 ? prayerStartingSpaces + 7: prayerStartingSpaces
        
        if (count <= start) {
            let day = daysInPrevMonth - (startingSpaces - count)
            let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerList: prayerList)
            return MonthStruct(monthType: MonthType.Previous, dayInt: day, prayerName: name, prayerRange: prayerRange)
        }
        
        else if ((count - startingSpaces) > daysInMonth) {
            let day = count - startingSpaces - daysInMonth
            let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerList: prayerList)
            return MonthStruct(monthType: MonthType.Next, dayInt: day, prayerName: name, prayerRange: prayerRange)
        }
        
        let day = count-start
        let name = prayerNameFunc(count: count, prayerRange: prayerRange, prayerList: prayerList)
        return MonthStruct(monthType: MonthType.Current, dayInt: day, prayerName: name, prayerRange: prayerRange)
    }
    
    func prayerNameFunc(count: Int, prayerRange: Int, prayerList: [String]) -> String {
        if prayerRange < 0 || prayerList.isEmpty { //(count - startingSpaces) + prayerRange <= 0) ||
            return ""
        }
        return prayerList[prayerRange % prayerList.count]
    }
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View {
       CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1, prayerStartingSpaces: 1, prayerList: ["Matt"], prayerRange: 1)
    }
}
