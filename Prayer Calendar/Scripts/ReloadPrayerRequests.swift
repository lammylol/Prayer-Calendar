//
//  ReloadPrayerRequests.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/28/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

class ReloadPrayerRequests {
    
    func getFriendsList(userID: String) async -> [String] {
        let db = Firestore.firestore()
        var friendsList: [String] = []
        
        do {
            let friendsListRef = db.collection("users").document(userID).collection("friendsList")
            let querySnapshot = try await friendsListRef.getDocuments()
    
            //append FriendsListArray in userHolder
            for document in querySnapshot.documents {
              print("\(document.documentID) => \(document.data())")
              friendsList.append(document.documentID)
            }
        } catch {
          print("Error getting documents: \(error)")
        }
        return friendsList
    }
    
    func updateRequests() async {
        let db = Firestore.firestore()
        var users: [String] = []
        do {
            let querySnapshot = try await db.collection("users").getDocuments()
            for document in querySnapshot.documents {
                //                print("\(document.documentID) => \(document.data())")
                users.append(document.documentID)
            }
        } catch {
            print("error getting users")
        }
        
        for user in users {
//                    var prayerListPeople: [String] = []
            let friendsList = await getFriendsList(userID: user)
            
            db.collection("users").document(user).collection("prayerList").whereField("userID", isEqualTo: user).getDocuments() { (snapshot, error) in
                let querySnapshot = snapshot!.documents
                
                for document in querySnapshot {
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
                    
                    print("user: \(user), prayerRequest: \(prayerRequest.id)")
                    PrayerRequestHelper().updatePrayerRequest(prayerRequest: prayerRequest, userID: userID, friendsList: friendsList)
                }
            }
        }
    }
}
