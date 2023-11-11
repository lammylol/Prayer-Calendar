//
//  UserPrayerProfile.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/8/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model final class PrayerRequestModel {
    @Attribute(.unique) var username: String
    var date: Date
    var prayerRequest: String
    var status: String
    
    init(username: String, date: Date, prayerRequest: String, status: String) {
        self.username = username
        self.date = date
        self.prayerRequest = prayerRequest
        self.status = status
    }
}

extension PrayerRequestModel {
    static var preview: PrayerRequestModel {
        let item = PrayerRequestModel(
            username: "Matt",
            date: Date(),
            prayerRequest: "Hello, World",
            status: "Still need prayer")
        return item
    }
}
