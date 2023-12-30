//
//  PrayerRequestHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/19/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

enum PrayerRequestRetrievalError: Error {
    case noUserID
//    case errorRetrievingFromFirebase
}

class PrayerRequestHelper {
    
    //Retrieve prayer requests from Firestore
    func retrievePrayerRequest(userID: String) async throws -> [PrayerRequest] {
        var prayerRequests = [PrayerRequest]()
        let db = Firestore.firestore()
        
        guard userID != "" else {
            throw PrayerRequestRetrievalError.noUserID
        }
        
        do {
          let querySnapshot = try await db.collection("users").document(userID).collection("prayerrequests").getDocuments()
            
          for document in querySnapshot.documents {
              print("\(document.documentID) => \(document.data())")
              let timestamp = document.data()["DatePosted"] as? Timestamp ?? Timestamp()
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

        
//        old snapshot listener.
//        ref.addSnapshotListener { documentSnapshot, error in
//            guard let document = documentSnapshot?.documents else {
//                print("Error fetching document: \(String(describing: error))")
//                return
//            }
//            
//            prayerRequests = document.map { (queryDocumentSnapshot) -> PrayerRequest in
//                let data = queryDocumentSnapshot.data()
//
//                let timestamp = data["DatePosted"] as? Timestamp ?? Timestamp()
//                let datePosted = timestamp.dateValue()
//                
//                let firstName = data["FirstName"] as? String ?? ""
//                let lastName = data["LastName"] as? String ?? ""
//                let prayerRequestText = data["PrayerRequestText"] as? String ?? ""
//                let status = data["Status"] as? String ?? ""
//                let userID = data["userID"] as? String ?? ""
//                let priority = data["Priority"] as? String ?? ""
//                let documentID = queryDocumentSnapshot.documentID as String
//                    
//                let prayerRequest = PrayerRequest(id: documentID, userID: userID, date: datePosted, prayerRequestText: prayerRequestText, status: status, firstName: firstName, lastName: lastName, priority: priority)
//                
//                return prayerRequest
//            }
//        }
        
        print(prayerRequests)
        return prayerRequests
    }
    
    // Update Prayer Requests off of given request from row selection
    func updatePrayerRequest(prayerRequest: PrayerRequest, userID: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID).collection("prayerrequests").document(prayerRequest.id)

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
        let ref = db.collection("users").document(userID).collection("prayerrequests").document(prayerRequest.id)
        
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
    
    func addPrayerRequest(userID: String, firstName: String, lastName: String, prayerRequestText: String, priority: String) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID).collection("prayerrequests").document()

        ref.setData([
            "DatePosted": Date(),
            "FirstName": firstName,
            "LastName": lastName,
            "Status": "Current",
            "PrayerRequestText": prayerRequestText,
            "userID": userID,
            "Priority": priority
        ])
    }
    
}
