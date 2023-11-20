//
//  DataHolder.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import Foundation
import SwiftUI
import Firebase
import Observation

@Observable class PrayerListHolder {
    var date = Date()
    var email: String = ""
    var uid: String = ""
    
    var prayerListArray: [String] = [""]
    var prayerList: String = ""
    var isLoggedIn: Bool = false
    var prayStartDate = Date()
}

