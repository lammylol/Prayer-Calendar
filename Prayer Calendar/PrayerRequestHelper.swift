//
//  PrayerRequestHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/19/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class PrayerRequestHelper {
    
    // Update Prayer Requests off of given request from row selection
    func updatePrayerRequest(prayerRequest: PrayerRequest, username: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(username).collection("prayerRequests").document("\(prayerRequest.id)")

        ref.setData([
            "DatePosted": Date(),
            "FirstName": prayerRequest.firstName,
            "LastName": prayerRequest.lastName,
            "Status": prayerRequest.status,
            "PrayerRequestText": prayerRequest.prayerRequestText,
            "userID": prayerRequest.username
        ])
    }
    
    func deletePrayerRequest(prayerRequest: PrayerRequest, username: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(username).collection("prayerRequests").document("\(prayerRequest.id)")
        
        ref.delete()
    }
}
