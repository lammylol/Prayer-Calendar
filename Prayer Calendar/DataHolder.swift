//
//  DataHolder.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import Foundation
import SwiftUI
import SwiftData

class DataHolder: ObservableObject {
    @Published var date = Date()
    @Published var prayerList: [String] = []
    @Published var prayerListString: String = ""
    @Published var dateDictionary: [Date: [String]] = [:]
    @Published var prayStartDate = Date()
    @Published var username: String = ""

//    private static func setDate(prayerStartDate: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.date(from: prayerStartDate)!
//    }
}
