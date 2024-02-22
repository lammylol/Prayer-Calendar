//
//  PrayerUpdateHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 2/18/24.
//

import Foundation
import FirebaseFirestore

class PrayerUpdateHelper {
    // this function gets all the prayer request updates from a specific prayer request passed through.
    func getPrayerRequestUpdates(prayerRequest: PrayerRequest, person: Person) async throws -> [PrayerRequestUpdate] {
        var updates = [PrayerRequestUpdate]()
        let db = Firestore.firestore()
        
        guard prayerRequest.id != "" else {
            throw PrayerRequestRetrievalError.noPrayerRequestID
        }
        
        do {
            let prayerRequestUpdates = db.collection("prayerRequests").document(prayerRequest.id).collection("updates").order(by: "datePosted", descending: false)
            
            let querySnapshot = try await prayerRequestUpdates.getDocuments()
            
            for document in querySnapshot.documents {
//                print("\(document.documentID) => \(document.data())")
                let timestamp = document.data()["datePosted"] as? Timestamp ?? Timestamp()
                //              let timestamp = document.data()["DatePosted"]/* as? ip_timestamp ?? ip_timestamp()*/
                let datePosted = timestamp.dateValue()
                
//                var id: String = ""
//                var prayerRequestID: String = "" // original identifier
//                var datePosted: Date
//                var prayerUpdateText: String
                
                let prayerRequestID = document.data()["prayerRequestID"] as? String ?? ""
                let prayerUpdateText = document.data()["prayerUpdateText"] as? String ?? ""
                let documentID = document.documentID as String
                
                let prayerRequestUpdate = PrayerRequestUpdate(id: documentID, prayerRequestID: prayerRequestID, datePosted: datePosted, prayerUpdateText: prayerUpdateText)
                
                updates.append(prayerRequestUpdate)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return updates
    }
    
    // this function enables the creation of an 'update' for an existing prayer request.
    func addPrayerRequestUpdate(datePosted: Date, prayerRequest: PrayerRequest, prayerRequestUpdate: PrayerRequestUpdate, person: Person, friendsList: [String] /*friendID: String, updateFriend: Bool*/){
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
         
        // Add prayer update within prayer request in user collection. Is this needed? No for now
//        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id).collection("updates").document() // get user collection
//        
//        ref.setData([
//            "datePosted": datePosted,
//            "prayerRequestID": prayerRequest.id,
//            "prayerUpdateText": prayerRequestUpdate.prayerUpdateText
//        ])
        
        // Add prayer request update into prayer request collection.
        let ref2 =
        db.collection("prayerRequests").document(prayerRequest.id).collection("updates").document() // get prayer request collection
        
        ref2.setData([
            "datePosted": datePosted,
            "prayerRequestID": prayerRequest.id,
            "prayerUpdateText": prayerRequestUpdate.prayerUpdateText
        ])
        
    // Add UpdateID and Data to prayerRequests/{prayerRequestID}/Updates
    // Reset latest update date and text for user id prayer list.
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.updateData([
            "latestUpdateDatePosted": datePosted,
            "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
        )
        
        // update the latestUpdateDatePosted and latestUpdateText in prayer request collection.
        let refPrayerRequestCollection = db.collection("prayerRequests").document(prayerRequest.id)
        
        refPrayerRequestCollection.updateData([
            "latestUpdateDatePosted": datePosted,
            "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
        )
        
        // Add prayer request update to prayerFeed/{userID} main prayerRequest
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    let refFriend = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                    refFriend.updateData([
                        "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                        "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
                    )
                }
            }
        } else {
            let refProfile = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
            refProfile.updateData([
                "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
            )
        }
    }
    
    //person passed in for the feed is the user. prayer passed in for the profile view is the person being viewed.
    func deletePrayerUpdate(prayerRequest: PrayerRequest, prayerRequestUpdate: PrayerRequestUpdate, updatesArray: [PrayerRequestUpdate], person: Person, friendsList: [String]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        //----------------- latest update date and text reset for original prayer request ---------------------
        // For resetting latest date and latest text.
        let latestUpdateDatePosted = getLatestUpdateDate(prayerRequest: prayerRequest, updates: updatesArray)
        let latestUpdateText = getLatestUpdateText(prayerRequest: prayerRequest, updates: updatesArray)
        
//      Reset latest update date and text for user id prayer list.
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.updateData([
            "latestUpdateDatePosted": latestUpdateDatePosted,
            "latestUpdateText": latestUpdateText]
        )
        
        // update the latestUpdateDatePosted and latestUpdateText in prayer request collection.
        let refPrayerRequestCollection = db.collection("prayerRequests").document(prayerRequest.id)
        
        refPrayerRequestCollection.updateData([
            "latestUpdateDatePosted": latestUpdateDatePosted,
            "latestUpdateText": latestUpdateText]
        )
        
        // Delete PrayerRequestID from prayerFeed/{userID}
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    let refFriend = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                    refFriend.updateData([
                        "latestUpdateDatePosted": latestUpdateDatePosted,
                        "latestUpdateText": latestUpdateText]
                    )
                }
            }
        } else {
            let refProfile = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
            refProfile.updateData([
                "latestUpdateDatePosted": latestUpdateDatePosted,
                "latestUpdateText": latestUpdateText]
            )
        }
        
        //----------------- delete prayer update from collection ---------------------
        
        // Delete prayer update from prayerRequests/{prayerRequestID}
        let refUpdate =
        db.collection("prayerRequests").document(prayerRequest.id).collection("updates").document(prayerRequestUpdate.id)
        
        refUpdate.delete()
    }
    
    // A function to always find the latest update datePosted. Particularly if an update is deleted, the function needs to find what the latest date was to repost to.
    func getLatestUpdateDate(prayerRequest: PrayerRequest, updates: [PrayerRequestUpdate]) -> Date {
        var latestUpdateDatePosted = Date()
        
        if updates.count >= 1 {
            // if there are more than 1 updates, then get datePosted of the latest update.
            // assume the array is sorted already on getPrayerUpdates
            latestUpdateDatePosted = updates.last?.datePosted ?? Date()
        } else {
            // if either there are no updates, or there will be no updates after delete, then get datePosted of the original prayer request.
            latestUpdateDatePosted = prayerRequest.date
        }
        
        return latestUpdateDatePosted
    }
    
    func getLatestUpdateText(prayerRequest: PrayerRequest, updates: [PrayerRequestUpdate]) -> String {
        var latestUpdateText = ""
        
        if updates.count >= 1 {
            // if there are more than 1 updates, then get datePosted of the latest update.
            // assume the array is sorted already on getPrayerUpdates
            latestUpdateText = updates.last?.prayerUpdateText ?? ""
        } else {
            // if either there are no updates, or there will be no updates after delete, then get datePosted of the original prayer request.
            latestUpdateText = ""
        }
        
        return latestUpdateText
    }
    
    //person passed in for the feed is the user. prayer passed in for the profile view is the person being viewed.
    func editPrayerUpdate(prayerRequest: PrayerRequest, prayerRequestUpdate: PrayerRequestUpdate, person: Person, friendsList: [String], updatesArray: [PrayerRequestUpdate]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        let latestUpdateDatePosted = getLatestUpdateDate(prayerRequest: prayerRequest, updates: updatesArray)
        
        if prayerRequestUpdate.datePosted == latestUpdateDatePosted  { // Only update latestUpdate to PrayerRequest if it is newer than the last.
            //      Reset latest update date and text for user id prayer list.
            let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
            
            ref.updateData([
                "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
            )
            
            // update the latestUpdateDatePosted and latestUpdateText in prayer request collection.
            let refPrayerRequestCollection = db.collection("prayerRequests").document(prayerRequest.id)
            
            refPrayerRequestCollection.updateData([
                "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
            )
            
            // Update PrayerRequestID in prayerFeed/{userID}
            if isMyProfile == true {
                if friendsList.isEmpty == false {
                    for friendID in friendsList {
                        let refFriend = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                        refFriend.updateData([
                            "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                            "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
                        )
                    }
                }
            } else {
                let refProfile = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
                refProfile.updateData([
                    "latestUpdateDatePosted": prayerRequestUpdate.datePosted,
                    "latestUpdateText": prayerRequestUpdate.prayerUpdateText]
                )
            }
        }
        
        //----------------- Update prayer update in collection ---------------------
        
        // Delete prayer update from prayerRequests/{prayerRequestID}
        let refUpdate =
        db.collection("prayerRequests").document(prayerRequest.id).collection("updates").document(prayerRequestUpdate.id)
        
        refUpdate.updateData([
//            "datePosted": datePosted,
//            "prayerRequestID": prayerRequest.id,
            "prayerUpdateText": prayerRequestUpdate.prayerUpdateText
        ])
    }
}
