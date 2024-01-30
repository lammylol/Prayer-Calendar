//
//  PrayerFeedHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/28/24.
//

import Foundation
import FirebaseFirestore

class PrayerFeedHelper {
    //Retrieve prayer requests for PrayerFeed.
    func retrievePrayerRequestFeed(userID: String) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        let db = Firestore.firestore()
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        do {
            let prayerFeed = db.collection("prayerFeed").document(userID).collection("prayerRequests").order(by: "datePosted", descending: true)

            let querySnapshot = try await prayerFeed.getDocuments()
            
            for document in querySnapshot.documents {
              print("\(document.documentID) => \(document.data())")
              let timestamp = document.data()["datePosted"] as? Timestamp ?? Timestamp()
            //              let timestamp = document.data()["DatePosted"]/* as? ip_timestamp ?? ip_timestamp()*/
              let datePosted = timestamp.dateValue()

              let firstName = document.data()["firstName"] as? String ?? ""
              let lastName = document.data()["lastName"] as? String ?? ""
              let prayerRequestText = document.data()["prayerRequestText"] as? String ?? ""
              let status = document.data()["status"] as? String ?? ""
              let userID = document.data()["userID"] as? String ?? ""
              let priority = document.data()["priority"] as? String ?? ""
              let documentID = document.documentID as String

              let prayerRequest = PrayerRequest(id: documentID, userID: userID, date: datePosted, prayerRequestText: prayerRequestText, status: status, firstName: firstName, lastName: lastName, priority: priority)
              
              prayerRequests.append(prayerRequest)
            }
            } catch {
            print("Error getting documents: \(error)")
            }
        
        print(prayerRequests)
        return prayerRequests
    }
}
