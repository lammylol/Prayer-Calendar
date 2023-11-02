//
//  UserPrayerProfile.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 10/8/23.
//

import Foundation
import SwiftUI
import SwiftData

@Model final class PrayerRequest {
    var email: String
    var startDate: Date
    var prayerRequest: String
    var status: String
    
    init(email: String, startDate: Date, prayerRequest: String, status: String) {
        self.email = email
        self.startDate = startDate
        self.prayerRequest = prayerRequest
        self.status = status
    }
}

//extension PrayerRequest {
//    static var preview: PrayerRequest {
//        let item = PrayerRequest(
//            username: "Matt",
//            date: Date(),
//            prayerRequest: "Hello, World",
//            status: "Still need prayer")
//        return item
//    }
//}
