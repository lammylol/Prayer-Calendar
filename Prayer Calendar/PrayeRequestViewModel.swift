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
                print("Error fetching document: \(String(describing: error))")
                return
            }
            
            self.prayerRequests = document.map { (queryDocumentSnapshot) -> PrayerRequest in
                let data = queryDocumentSnapshot.data()

                    let timestamp = data["DatePosted"] as? Timestamp ?? Timestamp()
                    let datePosted = timestamp.dateValue()
                    
                    let firstName = data["FirstName"] as? String ?? ""
                    let lastName = data["LastName"] as? String ?? ""
                    let prayerRequestText = data["PrayerRequestText"] as? String ?? ""
                    let status = data["Status"] as? String ?? ""
                    let userID = data["userID"] as? String ?? ""
                    
                let prayerRequest = PrayerRequest(username: userID, date: datePosted, prayerRequestText: prayerRequestText, status: status, firstName: firstName, lastName: lastName)
                    
                    print(prayerRequest)
                    return prayerRequest

            }
        }
    }
    
    func addPrayerRequest(username: String, firstName: String, lastName: String, prayerRequestText: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(username).collection("prayerRequests").document()

        ref.setData([
            "DatePosted": Date(),
            "FirstName": firstName,
            "LastName": lastName,
            "Status": "Current",
            "PrayerRequestText": prayerRequestText,
            "userID": username
        ])
    }
    
}
