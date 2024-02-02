//
//  PrayerRequest.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import Foundation

struct PrayerRequest : Identifiable {
    var id: String = ""
    var userID: String
    var username: String
    var date: Date
    var prayerRequestText: String
    var status: String
    var firstName: String
    var lastName: String
    var priority: String
}

extension PrayerRequest {
    static var preview: PrayerRequest {
        let item =
        PrayerRequest(
            userID: "Matt",
            username: "lammylol",
            date: Date(),
            prayerRequestText: "Hello, World",
            status: "Current",
            firstName: "Matt",
            lastName: "Lam",
            priority: "high")
        return item
    }
}
