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
            "DatePosted": prayerRequest.date,
            "FirstName": prayerRequest.firstName,
            "LastName": prayerRequest.lastName,
            "Status": prayerRequest.status,
            "PrayerRequestText": prayerRequest.prayerRequestText,
            "userID": prayerRequest.userID,
            "Priority": prayerRequest.priority
        ])
        
        print(prayerRequest.prayerRequestText)
    }
    
    func deletePrayerRequest(prayerRequest: PrayerRequest, username: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(username).collection("prayerRequests").document("\(prayerRequest.id)")
        
        ref.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfull deleted")
                print(prayerRequest.id)
                print(prayerRequest.prayerRequestText)
            }
        }
    }
}
