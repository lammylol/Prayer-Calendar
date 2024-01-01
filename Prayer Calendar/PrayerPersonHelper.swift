//
//  PrayerNameHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class PrayerPersonHelper {
    
//    This function retrieves PrayerList data from Firestore.
    func getPrayerList(userHolder: UserProfileHolder, prayerListHolder: PrayerListHolder) async {
            let ref = Firestore.firestore()
            .collection("prayerlists").document(userHolder.person.userID)
            
            ref.getDocument{(document, error) in
                if let document = document, document.exists {
                    
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: " + dataDescription)
                        
                        //Update Dataholder with PrayStartDate from Firestore
                        let startDateTimeStamp = document.get("prayStartDate") as! Timestamp
                        prayerListHolder.prayStartDate = startDateTimeStamp.dateValue()
                        
                        
                        //Update Dataholder with PrayerList from Firestore
                        prayerListHolder.prayerList = document.get("prayerList") as! String
                    
                } else {
                    print("Document does not exist")
                    prayerListHolder.prayerList = ""
                }
            }
    }

    // The following function returns an array of PrayerPerson's so that the view can grab both the username or name.
    func retrievePrayerPersonArray(prayerList: String) -> [PrayerPerson] {
        let ref = prayerList.components(separatedBy: "\n")
        var prayerArray: [PrayerPerson] = []
        var firstName = ""
        var lastName = ""
        var username = ""
        
        for person in ref {
            let array = person.split(separator: ";", omittingEmptySubsequences: true) // Separate name from username
            
            if array.count == 1 {
                username = "" // If the array is only 1, assume that there was no username entered.
            } else {
                username = String(array.last ?? "").trimmingCharacters(in: .whitespaces)
            }
            
            let nameArray = array.first?.split(separator: " ", omittingEmptySubsequences: true) // Separate First name from Last. If there is middle name, last name will only grab last of array.
            
            // nameArray?.count == 1 ensures that if user enters only first name, last name will be "", not first name.
            if nameArray?.count == 1 {
                firstName = String(nameArray?.first ?? "").trimmingCharacters(in: .whitespaces)
            } else {
                firstName = String(nameArray?.first ?? "").trimmingCharacters(in: .whitespaces)
                lastName = String(nameArray?.last ?? "").trimmingCharacters(in: .whitespaces)
            }
            
            let prayerPerson = PrayerPerson(username: username, firstName: firstName, lastName: lastName)
            prayerArray.append(prayerPerson)
        }
        
        return prayerArray
    }
    
    // Retrieve requested userID off of username
    func retrieveUserID(person: PrayerPerson,userHolder: UserProfileHolder) async -> String {
        var userID = ""
        let db = Firestore.firestore()
        let ref = db.collection("usernames").document(person.username)
        
        if person.username == userHolder.person.username {
            userID = userHolder.person.userID
        } else {
            do {
                let document = try await ref.getDocument()
                if document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: " + dataDescription)
                    
                    userID = document.get("userID") as! String
                } else {
                    print("Error Retrieving User ID. Document does not exist")
                }
            } catch {
                print("Error getting document: \(error)")
            }
        }
        
        print("username: \(person.username); userID: \(userID)")
        return userID
    }
    
    func checkIfUsernameExists(username: String) -> Bool {
        var check = Bool()
        
        let ref = Firestore.firestore()
            .collection("usernames")
            .document(username)
        
        ref.getDocument{(document, error) in
            if let document = document, document.exists {
                check = true
            } else {
                check = false
            }
        }
        
        return check
    }
    
    //  This function retrieves Userinfo data from Firestore.
    func getUserInfo(userID: String, email: String, userHolder: UserProfileHolder) async {
        
        userHolder.person.userID = userID
        userHolder.person.email = email
        
        let ref = Firestore.firestore().collection("userinfo").document(userID)
        
        ref.getDocument{(document, error) in
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: " + dataDescription)
                
                userHolder.person.firstName = document.get("firstName") as! String
                userHolder.person.lastName = document.get("lastName") as! String
                userHolder.person.username = document.get("username") as! String
                
            } else {
                print("Error retrieving user info. Some user info is passed as blank")
//                        userHolder.prayerList = ""
            }
        }

    }
}
