//
//  PrayerRequestHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/19/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFunctions

enum PrayerRequestRetrievalError: Error {
    case noUserID
//    case errorRetrievingFromFirebase
}

class PrayerRequestHelper {
    
    //Retrieve prayer requests from Firestore
    func getPrayerRequests(userID: String, person: Person) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        let db = Firestore.firestore()
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        do {
            let profiles = db.collection("users").document(userID).collection("prayerList").document("\(person.firstName.lowercased())_\(person.lastName.lowercased())").collection("prayerRequests").order(by: "datePosted", descending: true)
            
            let querySnapshot = try await profiles.getDocuments()
            
            for document in querySnapshot.documents {
//                print("\(document.documentID) => \(document.data())")
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
                let documentID = document.documentID as String
                let prayerRequestTitle = document.data()["prayerRequestTitle"] as? String ?? ""
                
                let prayerRequest = PrayerRequest(id: documentID, userID: userID, username: username, date: datePosted, prayerRequestText: prayerRequestText, status: status, firstName: firstName, lastName: lastName, priority: priority, prayerRequestTitle: prayerRequestTitle, latestUpdateText: "", latestUpdateDatePosted: datePosted)
                
                prayerRequests.append(prayerRequest)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return prayerRequests
    }
    
    // this function enables the creation and submission of a new prayer request. It does three things: 1) add to user collection of prayer requests, 2) add to prayer requests collection, and 3) adds the prayer request to all friends of the person only if the prayer request is the user's main profile.
    func createPrayerRequest(userID: String, datePosted: Date, person: Person, prayerRequestText: String, prayerRequestTitle: String, priority: String, friendsList: [String]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        // Create new PrayerRequestID to users/{userID}/prayerList/{person}/prayerRequests
        let ref = db.collection("users").document(userID).collection("prayerList").document("\(person.firstName.lowercased())_\(person.lastName.lowercased())").collection("prayerRequests").document()

        ref.setData([
            "datePosted": datePosted,
            "firstName": person.firstName,
            "lastName": person.lastName,
            "status": "Current",
            "prayerRequestText": prayerRequestText,
            "userID": userID,
            "username": person.username,
            "priority": priority,
            "prayerRequestTitle": prayerRequestTitle
        ])
        
        let prayerRequestID = ref.documentID
        
        // Add PrayerRequestID to prayerFeed/{userID}
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    let ref2 = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequestID)
                    ref2.setData([
                        "datePosted": datePosted,
                        "firstName": person.firstName,
                        "lastName": person.lastName,
                        "status": "Current",
                        "prayerRequestText": prayerRequestText,
                        "userID": userID,
                        "username": person.username,
                        "priority": priority,
                        "prayerRequestTitle": prayerRequestTitle
                    ])
                }
            }
        } else {
                let ref2 = db.collection("prayerFeed").document(userID).collection("prayerRequests").document(prayerRequestID)
                ref2.setData([
                    "datePosted": datePosted,
                    "firstName": person.firstName,
                    "lastName": person.lastName,
                    "status": "Current",
                    "prayerRequestText": prayerRequestText,
                    "userID": userID,
                    "username": person.username,
                    "priority": priority,
                    "prayerRequestTitle": prayerRequestTitle
                ])
        }
        
        // Add PrayerRequestID and Data to prayerRequests/{prayerRequestID}
        let ref3 =
        db.collection("prayerRequests").document(prayerRequestID)
        
        ref3.setData([
            "datePosted": datePosted,
            "firstName": person.firstName,
            "lastName": person.lastName,
            "status": "Current",
            "prayerRequestText": prayerRequestText,
            "userID": userID,
            "username": person.username,
            "priority": priority,
            "prayerRequestTitle": prayerRequestTitle
        ])
    }
    
    // This function enables an edit to a prayer requests off of a selected prayer request.
    func editPrayerRequest(prayerRequest: PrayerRequest, person: Person, friendsList: [String]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.updateData([
            "datePosted": prayerRequest.date,
            "firstName": prayerRequest.firstName,
            "lastName": prayerRequest.lastName,
            "status": prayerRequest.status,
            "prayerRequestText": prayerRequest.prayerRequestText,
            "userID": person.userID,
            "username": person.username,
            "priority": prayerRequest.priority,
            "prayerRequestTitle": prayerRequest.prayerRequestTitle
        ])
        
        // Add PrayerRequestID to prayerFeed/{userID}
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    updatePrayerFeed(prayerRequest: prayerRequest, person: person, friendID: friendID, updateFriend: true, isOriginalPrayerRequest: true)
                }
            }
        } else {
            updatePrayerFeed(prayerRequest: prayerRequest, person: person, friendID: "", updateFriend: false, isOriginalPrayerRequest: true)
        }
        
        // Add PrayerRequestID and Data to prayerRequests/{prayerRequestID}
        updatePrayerRequestsDataCollection(prayerRequest: prayerRequest, person: person, isOriginalPrayerRequest: true)
        print(prayerRequest.prayerRequestText)
    }
    
    // This function updates the prayer feed of all users who are friends of the person.
    func updatePrayerFeed(prayerRequest: PrayerRequest, person: Person, friendID: String, updateFriend: Bool, isOriginalPrayerRequest: Bool) {
        let db = Firestore.firestore()
        
        // isOriginalPrayerRequest == true. This means that the user is adding or updating the original prayer request. It is not a prayer 'update'.
        if isOriginalPrayerRequest == true {
            if updateFriend == true {
                let ref = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                ref.setData([
                    "datePosted": prayerRequest.date,
                    "firstName": prayerRequest.firstName,
                    "lastName": prayerRequest.lastName,
                    "status": prayerRequest.status,
                    "prayerRequestText": prayerRequest.prayerRequestText,
                    "userID": person.userID,
                    "username": person.username,
                    "priority": prayerRequest.priority,
                    "prayerRequestTitle": prayerRequest.prayerRequestTitle
                ])
            } else {
                // prayer request passed in is the update.
                let ref = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
                ref.updateData([
                    "latestUpdateDatePosted": prayerRequest.date,
                    "latestUpdateText": prayerRequest.prayerRequestText
                ])
            }
        } else { // isOriginalPrayerRequest == false. This means that the user is adding a prayer 'update'.
            if updateFriend == true {
                let ref = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                ref.setData([
                    "datePosted": prayerRequest.date,
                    "firstName": prayerRequest.firstName,
                    "lastName": prayerRequest.lastName,
                    "status": prayerRequest.status,
                    "prayerRequestText": prayerRequest.prayerRequestText,
                    "userID": person.userID,
                    "username": person.username,
                    "priority": prayerRequest.priority,
                    "prayerRequestTitle": prayerRequest.prayerRequestTitle
                ])
            } else {
                let ref = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
                ref.setData([
                    "datePosted": prayerRequest.date,
                    "firstName": prayerRequest.firstName,
                    "lastName": prayerRequest.lastName,
                    "status": prayerRequest.status,
                    "prayerRequestText": prayerRequest.prayerRequestText,
                    "userID": person.userID,
                    "username": person.username,
                    "priority": prayerRequest.priority,
                    "prayerRequestTitle": prayerRequest.prayerRequestTitle
                ])
            }
        }
    }
    
    // this function updates the prayer requests collection carrying all prayer requests. Takes in the prayer request being updated, and the person who is being updated for.
    func updatePrayerRequestsDataCollection(prayerRequest: PrayerRequest, person: Person, isOriginalPrayerRequest: Bool) {
        let db = Firestore.firestore()
        
        let ref =
        db.collection("prayerRequests").document(prayerRequest.id)
        
        if isOriginalPrayerRequest == true {
            ref.updateData([
                "datePosted": prayerRequest.date,
                "firstName": prayerRequest.firstName,
                "lastName": prayerRequest.lastName,
                "status": prayerRequest.status,
                "prayerRequestText": prayerRequest.prayerRequestText,
                "userID": person.userID,
                "username": person.username,
                "priority": prayerRequest.priority,
                "prayerRequestTitle": prayerRequest.prayerRequestTitle
            ])
        } else {
            ref.updateData([
                "latestUpdateDatePosted": prayerRequest.date,
                "latestUpdateText": prayerRequest.prayerRequestText])
        }

    }
    
    //person passed in for the feed is the user. prayer passed in for the profile view is the person being viewed.
    func deletePrayerRequest(prayerRequest: PrayerRequest, person: Person, friendsList: [String]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully deleted")
                print(prayerRequest.id)
                print(prayerRequest.prayerRequestText)
            }
        }
        
        // Delete PrayerRequestID from prayerFeed/{userID}
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    let ref2 = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                    ref2.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully deleted")
                            print(prayerRequest.id)
                            print(prayerRequest.prayerRequestText)
                        }
                    }
                }
            }
        } else {
            let ref2 = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
            ref2.delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully deleted")
                    print(prayerRequest.id)
                    print(prayerRequest.prayerRequestText)
                }
            }
        }
        
        // Add PrayerRequestID and Data to prayerRequests/{prayerRequestID}
        let ref3 =
        db.collection("prayerRequests").document(prayerRequest.id)
        
        ref3.delete()
    }
    
    // this function enables the creation of an 'update' for an existing prayer request.
    func addPrayerRequestUpdate(datePosted: String, prayerRequest: PrayerRequest, prayerRequestUpdate: PrayerRequestUpdate, person: Person, friendsList: [String] /*friendID: String, updateFriend: Bool*/){
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        // Add prayer request update within each prayer request in user collection and in prayer request collection
        
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id).collection("updates").document()
        
        ref.setData([
            "datePosted": datePosted,
            "prayerUpdateText": prayerRequestUpdate.prayerUpdateText
        ])
        
        let ref2 =
        db.collection("prayerRequests").document(prayerRequest.id).collection("updates").document()
        
        ref2.setData([
            "datePosted": datePosted,
            "prayerUpdateText": prayerRequestUpdate.prayerUpdateText
        ])
        
        var prayerRequest = prayerRequest.self
        prayerRequest.latestUpdateDatePosted = prayerRequestUpdate.date
        prayerRequest.latestUpdateText = prayerRequestUpdate.prayerUpdateText
        
        print(prayerRequest.latestUpdateText)
        print(prayerRequest.latestUpdateDatePosted)
        // Add UpdateID and Data to prayerRequests/{prayerRequestID}/Updates
        updatePrayerRequestsDataCollection(prayerRequest: prayerRequest, person: person, isOriginalPrayerRequest: false)
        
        // Add prayer request update to prayerFeed/{userID} main prayerRequest
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    updatePrayerFeed(prayerRequest: prayerRequest, person: person, friendID: friendID, updateFriend: true, isOriginalPrayerRequest: false) // isOriginalPrayerRequest is false because this is an update.
                }
            }
        } else {
            updatePrayerFeed(prayerRequest: prayerRequest, person: person, friendID: "", updateFriend: false, isOriginalPrayerRequest: false)
        }
    
    }
    
}
