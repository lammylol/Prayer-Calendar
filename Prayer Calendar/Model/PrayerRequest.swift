//
//  PrayerRequest.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import Foundation

struct PrayerRequest : Identifiable, Observable, Hashable {
    var id: String = ""
    var userID: String
    var username: String
    var date: Date
    var prayerRequestText: String
    var status: String
    var firstName: String
    var lastName: String
    var privacy: String
    var isPinned: Bool
    var prayerRequestTitle: String
    var latestUpdateText: String
    var latestUpdateDatePosted: Date
    var latestUpdateType: String
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
            privacy: "high",
            isPinned: true,
            prayerRequestTitle: "Test this is Title djaskldjklsajdklasjdklasjdklajsdlkasjdklajdklajdklajsdklasjdklasjdklasjdaklsdjaldjklad",
            latestUpdateText: "Test Latest Update.",
            latestUpdateDatePosted: Date(), 
            latestUpdateType: "Update"
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
            privacy: "",
            isPinned: false,
            prayerRequestTitle: "",
            latestUpdateText: "",
            latestUpdateDatePosted: Date(),
            latestUpdateType: "Update")
        return item
    }
}

struct PrayerRequestUpdate : Identifiable {
    var id: String = ""
    var prayerRequestID: String = "" // original identifier
    var datePosted: Date
    var prayerUpdateText: String
    var updateType: String
}

extension PrayerRequestUpdate {
    static var blank: PrayerRequestUpdate {
        let item =
        PrayerRequestUpdate(
            prayerRequestID: "",
            datePosted: Date(),
            prayerUpdateText: "",
            updateType: "Update")
        return item
    }
}
