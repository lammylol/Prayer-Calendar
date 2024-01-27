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
    
    //Retrieve prayerFeed for each user
    func retrieveFeed(userID: String) {
        
    }
    
    //Retrieve prayer requests from Firestore
    func retrievePrayerRequest(userID: String, person: PrayerPerson) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        let db = Firestore.firestore()
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        do {
            let profiles = db.collection("users").document(userID).collection("prayerList").document("\(person.firstName.lowercased())_\(person.lastName.lowercased())").collection("prayerRequests").order(by: "DatePosted", descending: true)

            let querySnapshot = try await profiles.getDocuments()
            
          for document in querySnapshot.documents {
              print("\(document.documentID) => \(document.data())")
              let timestamp = document.data()["DatePosted"] as? Timestamp ?? Timestamp()
//              let timestamp = document.data()["DatePosted"]/* as? ip_timestamp ?? ip_timestamp()*/
              let datePosted = timestamp.dateValue()

              let firstName = document.data()["FirstName"] as? String ?? ""
              let lastName = document.data()["LastName"] as? String ?? ""
              let prayerRequestText = document.data()["PrayerRequestText"] as? String ?? ""
              let status = document.data()["Status"] as? String ?? ""
              let userID = document.data()["userID"] as? String ?? ""
              let priority = document.data()["Priority"] as? String ?? ""
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
    func updatePrayerRequest(prayerRequest: PrayerRequest, userID: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)

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
    
    func deletePrayerRequest(prayerRequest: PrayerRequest, userID: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID).collection("prayerList").document("\(prayerRequest.firstName.lowercased())_\(prayerRequest.lastName.lowercased())").collection("prayerRequests").document(prayerRequest.id)
        
        ref.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully deleted")
                print(prayerRequest.id)
                print(prayerRequest.prayerRequestText)
            }
        }
    }
    
    func addPrayerRequest(userID: String, person: PrayerPerson, prayerRequestText: String, priority: String) {
        let db = Firestore.firestore()
        
        // Create new PrayerRequestID to users/{userID}/prayerList/{person}/prayerRequests
        let ref = db.collection("users").document(userID).collection("prayerList").document("\(person.firstName.lowercased())_\(person.lastName.lowercased())").collection("prayerRequests").document()

        ref.setData([
            "DatePosted": Date(),
            "FirstName": person.firstName,
            "LastName": person.lastName,
            "Status": "Current",
            "PrayerRequestText": prayerRequestText,
            "userID": userID,
            "Priority": priority
        ])
        
        var prayerRequestID = ref.documentID
        
        // Add PrayerRequestID to prayerRequests/{userID}/prayerFeed
        
        let ref2 =
        db.collection("prayerRequests").document(userID).collection("prayerFeed").document(prayerRequestID)
        
        // Create new PrayerRequestDoc to bring in.
        
        
    }
    
}
