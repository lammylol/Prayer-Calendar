//
//  PrayerRequest.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import Foundation

struct PrayerRequest : Identifiable {
    var id = UUID()
    var username: String
    var date: Date
    var prayerRequestText: String
    var status: String
    var firstName: String
    var lastName: String
    var priority: String
    
    init(id: UUID = UUID(), username: String, date: Date, prayerRequestText: String, status: String, firstName: String, lastName: String, priority: String) {
        self.id = id
        self.username = username
        self.date = date
        self.prayerRequestText = prayerRequestText
        self.status = status
        self.firstName = firstName
        self.lastName = lastName
        self.priority = priority
    }
}

extension PrayerRequest {
    static var preview: PrayerRequest {
        let item =
        PrayerRequest(
            username: "Matt",
            date: Date(),
            prayerRequestText: "Hello, World",
            status: "Current",
            firstName: "Matt",
            lastName: "Lam",
            priority: "high")
        return item
    }
}

struct PrayerRequestsModel {
    static var preview: [PrayerRequest] =
        [PrayerRequest(
            username: "Matt",
            date: Date(),
            prayerRequestText: "Hello, World",
            status: "Current",
            firstName: "Matt",
            lastName: "Lam",
            priority: "high"),
         PrayerRequest(
            username: "Jane",
            date: Date(),
            prayerRequestText: "Hello, Jane",
            status: "Past",
            firstName: "Jane",
            lastName: "Choi",
            priority: "high"
         )]
}
