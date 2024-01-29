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
    func retrievePrayerRequest(userID: String, person: PrayerPerson) async throws -> [PrayerRequest] {
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
    
    // Update Prayer Requests off of given request from row selection
    func updatePrayerRequest(prayerRequest: PrayerRequest, person: PrayerPerson, friendsList: [String]) {
        let db = Firestore.firestore()
        
        var isMyProfile: Bool
        if person.username != "" && person.userID == prayerRequest.userID {
            isMyProfile = true
        } else {
            isMyProfile = false
        }
        
        let ref = db.collection("users").document(person.userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.setData([
            "datePosted": prayerRequest.date,
            "firstName": prayerRequest.firstName,
            "lastName": prayerRequest.lastName,
            "status": prayerRequest.status,
            "prayerRequestText": prayerRequest.prayerRequestText,
            "userID": prayerRequest.userID,
            "priority": prayerRequest.priority
        ])
        
        // Add PrayerRequestID to prayerFeed/{userID}
        if isMyProfile == true {
            if friendsList.isEmpty == false {
                for friendID in friendsList {
                    let ref2 = db.collection("prayerFeed").document(friendID).collection("prayerRequests").document(prayerRequest.id)
                    ref2.setData([
                        "datePosted": prayerRequest.date,
                        "firstName": prayerRequest.firstName,
                        "lastName": prayerRequest.lastName,
                        "status": prayerRequest.status,
                        "prayerRequestText": prayerRequest.prayerRequestText,
                        "userID": prayerRequest.userID,
                        "priority": prayerRequest.priority
                    ])
                }
            }
        } else {
            let ref2 = db.collection("prayerFeed").document(person.userID).collection("prayerRequests").document(prayerRequest.id)
            ref2.setData([
                "datePosted": prayerRequest.date,
                "firstName": prayerRequest.firstName,
                "lastName": prayerRequest.lastName,
                "status": prayerRequest.status,
                "prayerRequestText": prayerRequest.prayerRequestText,
                "userID": prayerRequest.userID,
                "priority": prayerRequest.priority
            ])
        }
        
        // Add PrayerRequestID and Data to prayerRequests/{prayerRequestID}
        let ref3 =
        db.collection("prayerRequests").document(prayerRequest.id)
        
        ref3.setData([
            "datePosted": prayerRequest.date,
            "firstName": prayerRequest.firstName,
            "lastName": prayerRequest.lastName,
            "status": prayerRequest.status,
            "prayerRequestText": prayerRequest.prayerRequestText,
            "userID": prayerRequest.userID,
            "priority": prayerRequest.priority
        ])
        
        print(prayerRequest.prayerRequestText)
    }
    
    func deletePrayerRequest(prayerRequest: PrayerRequest, person: PrayerPerson, friendsList: [String]) {
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
    
    func addPrayerRequest(userID: String, datePosted: Date, person: PrayerPerson, prayerRequestText: String, priority: String, friendsList: [String]) {
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
            "priority": priority
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
                        "priority": priority
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
                    "priority": priority
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
            "priority": priority
        ])
    }
    
}
