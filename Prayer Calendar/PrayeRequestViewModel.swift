//
//  PrayeRequestModel.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/12/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@Observable class PrayerRequestViewModel {
    var prayerRequests = [PrayerRequest]()
    let db = Firestore.firestore()

    //Retrieve prayer requests from Firestore
    func retrievePrayerRequest(username: String) {
        let ref = db.collection("users").document(username).collection("prayerRequests")
        
        ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error)")
                return
            }
        
            self.prayerRequests = document.map { (queryDocumentSnapshot) -> PrayerRequest in
                let data = queryDocumentSnapshot.data()
                
                let timestamp = data["DatePosted"] as! Timestamp
                let datePosted = timestamp.dateValue()
                
                let firstName = data["FirstName"]
                let lastName = data["LastName"]
                let prayerRequestText = data["prayerRequestText"]
                let status = data["Status"]
                let userID = data["userID"]
                
                let prayerRequest = PrayerRequest(username: userID as! String, date: datePosted, prayerRequestText: prayerRequestText as! String, status: status as! String, firstName: firstName as! String, lastName: lastName as! String)
                
                print(prayerRequest)
                return prayerRequest
            }
        }
    }
}
