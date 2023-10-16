//
//  DataHolder.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable class DataHolder {
    var date = Date()
    var username: String = ""
    
    var prayerListArray: [String] = [""]
    var prayerList: String = ""
    var dateDictionary: [Date: [String]] = [:]
    var prayStartDate = Date()
}
