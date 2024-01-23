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
            .collection("users").document(userHolder.person.userID)
        
//            //old data structure
//            let ref = Firestore.firestore()
//            .collection("prayerlists").document(userHolder.person.userID)
            
            ref.getDocument{(document, error) in
                if let document = document, document.exists {
                    
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: " + dataDescription)
                    
                        //Update Dataholder with PrayStartDate from Firestore
                    let startDateTimeStamp = document.get("prayStartDate") as? Timestamp ?? Timestamp(date: Date())
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
                username = String(array.last ?? "").trimmingCharacters(in: .whitespaces).lowercased()
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
    func retrieveUserInfoFromUsername(person: PrayerPerson,userHolder: UserProfileHolder) async -> PrayerPerson {
        var userID = ""
        var firstName = person.firstName
        var lastName = person.lastName
        
        if person.username == "" {
            userID = userHolder.person.userID
        } else {
            do {
                let db = Firestore.firestore()
                
                //                //old data structure
                //                let ref = db.collection("usernames").document(person.username)
                
                let ref = try await db.collection("users").whereField("username", isEqualTo: person.username).getDocuments()
                
                for document in ref.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    if document.exists {
                        let dataDescription = document.data()
                        print("Document data: \(dataDescription)")
                        
                        userID = document.get("userID") as? String ?? ""
                        firstName = document.get("firstName") as? String ?? ""
                        lastName = document.get("lastName") as? String ?? ""
                    } else {
                        print("Error Retrieving User ID. Document does not exist")
                    }
                }
            } catch {
                    print("Error getting document: \(error)")
            }
        }
        
        print("username: \(person.username); userID: \(userID); firstName: \(firstName); lastName: \(lastName)")
        return PrayerPerson(userID: userID, username: person.username, firstName: firstName, lastName: lastName)
    }
    
    func checkIfUsernameExists(username: String) async -> Bool {
        var check = Bool()
        
        let db = Firestore.firestore()
        
        do {
            let ref = try await db.collection("users").whereField("username", isEqualTo: username).getDocuments()
            
            if ref.isEmpty {
                check = false
            } else {
                check = true
            }
        } catch {
            print("Error retrieving username ref")
            check = false
        }
        
        return check
        
//        let ref = Firestore.firestore()
//            .collection("usernames")
//            .document(username.lowercased())
//        
//        ref.getDocument{(document, error) in
//            if let document = document, document.exists {
//                check = true
//            } else {
//                check = false
//            }
//        }
    }
    
    //  This function retrieves Userinfo data from Firestore.
    func getUserInfo(userID: String, email: String, userHolder: UserProfileHolder) async {
        
        userHolder.person.userID = userID
        userHolder.person.email = email
        
        let ref = Firestore.firestore().collection("users").document(userID)
        
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
