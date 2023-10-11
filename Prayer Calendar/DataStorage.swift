//
//  DataStorage.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/8/23.
//

import SwiftUI
import SwiftData

@Model
class UserPrayerProfile {
    @Attribute(.unique) var username: String
    var prayStartDate: Date
    var prayerListString: String
    
    init(username: String, prayStartDate: Date, prayerListString: String) {
        self.username = username
        self.prayStartDate = prayStartDate
        self.prayerListString = prayerListString
    }
}
