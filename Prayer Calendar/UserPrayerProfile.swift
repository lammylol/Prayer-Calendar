//
//  UserPrayerProfile.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/8/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model final class UserPrayerProfile {
    //@Attribute(.unique)
    var username: String
    var date: Date
    var prayStartDate: Date
    var prayerListString: String
    
    init(username: String, date: Date, prayStartDate: Date, prayerListString: String) {
        self.username = username
        self.date = date
        self.prayStartDate = prayStartDate
        self.prayerListString = prayerListString
    }
}

extension UserPrayerProfile {
    static var preview: UserPrayerProfile {
        let item = UserPrayerProfile(
            username: "Matt",
            date: Date(),
            prayStartDate: Date(),
            prayerListString: "Matt\nEsther\nDavid")
        return item
    }
}
