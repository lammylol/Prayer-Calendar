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
            lastName: "Lam")
        return item
    }
}

struct PrayerRequestModel {
    static var preview: [PrayerRequest] =
        [PrayerRequest(
            username: "Matt",
            date: Date(),
            prayerRequestText: "Hello, World",
            status: "Current",
            firstName: "Matt",
            lastName: "Lam"),
         PrayerRequest(
            username: "Jane",
            date: Date(),
            prayerRequestText: "Hello, Jane",
            status: "Past",
            firstName: "Jane",
            lastName: "Choi"
         )]
}
