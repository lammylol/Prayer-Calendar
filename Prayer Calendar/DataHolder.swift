//
//  DataHolder.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import Observation
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable class DataHolder {
    var date = Date()
    var email: String = ""
    
    var prayerListArray: [String] = [""]
    var prayerList: String = ""
    var dateDictionary: [Date: [String]] = [:]
    var prayStartDate = Date()
}
