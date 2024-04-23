//
//  PrayerFeedHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/28/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class PrayerFeedHelper {
    let db = Firestore.firestore()
    
    func getAllPrayerRequestsQuery(userID: String) -> Query {
        db.collection("prayerFeed").document(userID).collection("prayerRequests")
    }
    
    func getAllPrayerRequestsByStatusQuery(userID: String, status: String) -> Query {
        db.collection("prayerFeed").document(userID).collection("prayerRequests")
            .whereField("status", isEqualTo: status)
            .order(by: "latestUpdateDatePosted", descending: true)
    }
    
    func getPrayerRequests(querySnapshot: QuerySnapshot) -> ([PrayerRequest], DocumentSnapshot?) {
        var prayerRequests = [PrayerRequest]()
        var lastDocument: DocumentSnapshot? = nil
        
        for document in querySnapshot.documents {
            let timestamp = document.data()["datePosted"] as? Timestamp ?? Timestamp()
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
            print("prayerRequest: "+prayerRequest.id+"lastDocument: "+(querySnapshot.documents.last?.documentID ?? ""))
            lastDocument = querySnapshot.documents.last
        }
        return (prayerRequests, lastDocument)
    }
    
    //Retrieve prayer requests for PrayerFeed.
    func retrievePrayerRequestFeed(userID: String, answeredFilter: String) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        
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
                    .order(by: "latestUpdateDatePosted", descending: true)
//                    .order(by: "status")
                    .whereField("status", isNotEqualTo: "Answered")
            } else { //if 'pinned'
                prayerFeed = db.collection("prayerFeed").document(userID).collection("prayerRequests")
                    .order(by: "latestUpdateDatePosted", descending: true)
                    .whereField("isPinned", isEqualTo: true)
//                    .order(by: "status")
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
    
    func getPrayerRequestFeed(userID: String, answeredFilter: String, count: Int, lastDocument: DocumentSnapshot?) async throws -> ([PrayerRequest], DocumentSnapshot?) {
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        var prayerFeed: Query
        
        //answeredFilter is true if only filtering on answered prayers.
        if answeredFilter == "answered" {
            prayerFeed = getAllPrayerRequestsByStatusQuery(userID: userID, status: "Answered")
        } else if answeredFilter == "current" {
            prayerFeed = getAllPrayerRequestsByStatusQuery(userID: userID, status: "Current")
        } else { //if 'pinned'
            prayerFeed = getAllPrayerRequestsQuery(userID: userID)
                .whereField("isPinned", isEqualTo: true)
                .order(by: "latestUpdateDatePosted", descending: true)
        }
        
        var querySnapshot: QuerySnapshot
        
        if lastDocument != nil /*&& progressStatus == true*/ {
            querySnapshot =
            try await prayerFeed
                .limit(to: count)
                .start(afterDocument: lastDocument!)
                .getDocuments()
        } else {
            querySnapshot =
            try await prayerFeed
                .limit(to: count)
                .getDocuments()
        }
        
        print(querySnapshot.count)
        
        return getPrayerRequests(querySnapshot: querySnapshot)
    }
}
