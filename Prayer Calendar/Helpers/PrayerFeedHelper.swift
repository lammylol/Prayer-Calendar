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
    func retrievePrayerRequestFeed(userID: String, answeredFilter: String) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        let db = Firestore.firestore()
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        do {
            var prayerFeed: Query
            
            //answeredFilter is true if only filtering on answered prayers.
            if answeredFilter == "answered" {
                prayerFeed = db.collection("prayerFeed").document(userID).collection("prayerRequests").whereField("status", isEqualTo: "Answered").order(by: "latestUpdateDatePosted", descending: true)
            } else if answeredFilter == "current" {
                prayerFeed = db.collection("prayerFeed").document(userID).collection("prayerRequests")
                    .order(by: "status")
                    .whereField("status", isNotEqualTo: "Answered")
                    .order(by: "latestUpdateDatePosted", descending: true)
            } else { //if 'pinned'
                prayerFeed = db.collection("prayerFeed").document(userID).collection("prayerRequests").order(by: "status")
                    .whereField("isPinned", isEqualTo: true)
                    .order(by: "latestUpdateDatePosted", descending: true)
            }

            let querySnapshot = try await prayerFeed.getDocuments()
            
            for document in querySnapshot.documents {
                let timestamp = document.data()["datePosted"] as? Timestamp ?? Timestamp()
                //              let timestamp = document.data()["DatePosted"]/* as? ip_timestamp ?? ip_timestamp()*/
                let datePosted = timestamp.dateValue()

                let firstName = document.data()["firstName"] as? String ?? ""
                let lastName = document.data()["lastName"] as? String ?? ""
                let prayerRequestText = document.data()["prayerRequestText"] as? String ?? ""
                let status = document.data()["status"] as? String ?? ""
                let userID = document.data()["userID"] as? String ?? ""
                let username = document.data()["username"] as? String ?? ""
                let priority = document.data()["priority"] as? String ?? ""
                let isPinned = document.data()["isPinned"] as? Bool ?? false
                let prayerRequestTitle = document.data()["prayerRequestTitle"] as? String ?? ""
                let documentID = document.documentID as String
                let latestUpdateText = document.data()["latestUpdateText"] as? String ?? ""
                let latestUpdateType = document.data()["latestUpdateType"] as? String ?? ""

                let updateTimestamp = document.data()["latestUpdateDatePosted"] as? Timestamp ?? timestamp
                let latestUpdateDatePosted = updateTimestamp.dateValue()

                let prayerRequest = PrayerRequest(id: documentID, userID: userID, username: username, date: datePosted, prayerRequestText: prayerRequestText, status: status, firstName: firstName, lastName: lastName, priority: priority, isPinned: isPinned, prayerRequestTitle: prayerRequestTitle, latestUpdateText: latestUpdateText, latestUpdateDatePosted: latestUpdateDatePosted, latestUpdateType: latestUpdateType)
              
              prayerRequests.append(prayerRequest)
            }
            } catch {
            print("Error getting documents: \(error)")
            }
        
        return prayerRequests
    }
}
