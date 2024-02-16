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
    var prayerRequestTitle: String
    var latestUpdateText: String
    var latestUpdateDatePosted: Date
}

extension PrayerRequest {
    static var preview: PrayerRequest {
        let item =
        PrayerRequest(
            userID: "Matt",
            username: "lammylol",
            date: Date(),
            prayerRequestText: "Hello, World ajsdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjdklasjldkjas",
            status: "Current",
            firstName: "Matt",
            lastName: "Lam",
            priority: "high",
            prayerRequestTitle: "Test this is Title djaskldjklsajdklasjdklasjdklajsdlkasjdklajdklajdklajsdklasjdklasjdklasjdaklsdjaldjklad",
            latestUpdateText: "Test Latest Update.",
            latestUpdateDatePosted: Date()
        )
        return item
    }
    
    static var blank: PrayerRequest {
        let item =
        PrayerRequest(
            userID: "",
            username: "",
            date: Date(),
            prayerRequestText: "",
            status: "",
            firstName: "",
            lastName: "",
            priority: "",
            prayerRequestTitle: "",
            latestUpdateText: "",
            latestUpdateDatePosted: Date())
        return item
    }
}

struct PrayerRequestUpdate : Identifiable {
    var id: String = ""
    var date: Date
    var prayerUpdateText: String
}

extension PrayerRequestUpdate {
    static var blank: PrayerRequestUpdate {
        let item =
        PrayerRequestUpdate(
            date: Date(),
            prayerUpdateText: "")
        return item
    }
}
