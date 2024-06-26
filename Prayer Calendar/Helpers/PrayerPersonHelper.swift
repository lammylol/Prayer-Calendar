//
//  PrayerNameHelper.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/23/23.

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

enum PrayerPersonRetrievalError: Error {
    case noUsername
    case incorrectUsername
    case errorRetrievingFromFirebase
}

class PrayerPersonHelper { // This class provides functions to retrieve, edit, and delete user profile data.
    
    let db = Firestore.firestore() // initiaties Firestore
    
    // Functions used at login: getPrayerList(), retrievePrayerPersonArray(), getUserInfo()
    
    func getUserInfo(person: Person, userHolder: UserProfileHolder) async { // This function retrieves user info at login.
        do {
            let ref = db.collection("users").document(person.userID)
            let document = try await ref.getDocument()
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: " + dataDescription)
            
            let firstName = document.get("firstName") as! String
            let lastName = document.get("lastName") as! String
            let username = document.get("username") as! String
            let userID = document.get("userID") as! String
            
            let prayerPerson = Person(userID: userID, username: username, email: userHolder.email, firstName: firstName, lastName: lastName)
            print("/username: " + prayerPerson.username)
            
            userHolder.person = prayerPerson // update userHolder with person information
            
            let (pinnedPrayerRequests, lastDocument) = try await PrayerFeedHelper().getPrayerRequestFeed(user: userHolder.person, person: person, answeredFilter: "pinned", count: 5, lastDocument: nil, profileOrFeed: "feed") // retrieve pinned prayer requests
            
            userHolder.pinnedPrayerRequests = pinnedPrayerRequests // set pinned prayer requests to userHolder.
            print("//username: " + userHolder.person.username)
        } catch {
            print("Error retrieving user info.")
        } // get user information and save it to userHolder.person
                
        do {
            let friendsListRef = db.collection("users").document(person.userID).collection("friendsList")
            let querySnapshot = try await friendsListRef.getDocuments()

            //append FriendsListArray in userHolder
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
                userHolder.friendsList.append(document.documentID)
            }
        } catch {
          print("Error getting documents: \(error)")
        } // get friends list and add that to userholder.friendslist
    }
    
    func getPrayerList(userHolder: UserProfileHolder) async { // This function retrieves calendar prayer list data from Firestore.
            let ref = db.collection("users").document(userHolder.person.userID)
        
            do {
                let document = try await ref.getDocument()
                if document.exists { // Update userHolder with prayer list details from Firestore
                    let startDateTimeStamp = document.get("prayStartDate") as? Timestamp ?? Timestamp(date: Date())
                    userHolder.prayStartDate = startDateTimeStamp.dateValue()
                    userHolder.prayerList = document.get("prayerList") as? String ?? ""
                } else {
                    print("Document does not exist")
                    userHolder.prayerList = ""
                }
            } catch {
                print(error.localizedDescription)
            }
    }
    
    func retrievePrayerPersonArray(prayerList: String) -> [Person] { // This function accepts a prayer list string (from firestore) and returns an array of PrayerPerson's so that the view can grab both the username or name. A prayer list may look like the following: "Matt Lam;lammylol\nEsther Choi;heej\nJoe". Some may have usernames, some may now.
        
        let prayerListArray = prayerList.components(separatedBy: "\n") // Create an array separated by \n within the prayer list string.
        
        var prayerArray: [Person] = [] // Empty array of Person type.
        var firstName = ""
        var lastName = ""
        var username = ""
        
        for person in prayerListArray {
            
            let array = person.split(separator: ";", omittingEmptySubsequences: true) // For each person in the array, separate out the array that contains either: [name] or [name, username].
            
            if array.count == 1 { // If the array is [name], then there is no username.
                username = ""
            } else { // If the array has [name, username], then username is equal to the last of the array.
                username = String(array.last ?? "").trimmingCharacters(in: .whitespaces).lowercased()
            }
            
            let nameArray = array.first?.split(separator: " ", omittingEmptySubsequences: true) // Split first name from last name from the name portion of the person. If there is middle name, last name will only grab last of array.
        
            if nameArray?.count == 1 { // nameArray?.count == 1 ensures that if user enters only first name, last name will be "", not first name.
                firstName = String(nameArray?.first ?? "").trimmingCharacters(in: .whitespaces)
                lastName = ""
            } else {
                firstName = String(nameArray?.first ?? "").trimmingCharacters(in: .whitespaces)
                lastName = String(nameArray?.last ?? "").trimmingCharacters(in: .whitespaces)
            }
            
            let prayerPerson = Person(username: username, firstName: firstName, lastName: lastName) // set userID as default user. Upon load, it will check if username exists. If username exists, then will load userID first.
            
            prayerArray.append(prayerPerson)
        } // For each person in the array, separate out the array that contains either: [name] or [name, username]. Create a person object from that data and append to prayer list array.
        
        return prayerArray
    }
    
    func retrieveUserInfoFromUsername(person: Person, userHolder: UserProfileHolder) async throws -> Person {
        
        var userID = person.userID
        var firstName = person.firstName
        var lastName = person.lastName
        
        if person.userID == "" { // Only perform if the person's userID is empty. If not, assume the data for the user already exists.
            if person.username == "" { // If the username is empty, this person was 'created' by the user, so retrieve user's userID.
                userID = userHolder.person.userID
            } else { // If username exists, then request user document from firestore off of the username.
                do {
                    let ref = try await db.collection("users").whereField("username", isEqualTo: person.username).getDocuments()
                    
                    for document in ref.documents {
                        if document.exists {
//                            let dataDescription = document.data()
                            userID = document.get("userID") as? String ?? ""
                            firstName = document.get("firstName") as? String ?? ""
                            lastName = document.get("lastName") as? String ?? ""
                        } else {
                            throw PrayerPersonRetrievalError.noUsername
                        }
                    }
                } catch {
                    print("Error getting document: \(error)")
                }
            }
        }
        print("username: \(person.username); userID: \(userID); firstName: \(firstName); lastName: \(lastName)")
        return Person(userID: userID, username: person.username, firstName: firstName, lastName: lastName)
    } // This function takes in a person object and returns additional information about the person. ie. if a user is accessing a profile for a username, this will retrieve information needed to fetch their data.
    
    func updatePrayerListData(userID: String, prayStartDate: Date, prayerList: String) {
        let ref = db.collection("users").document(userID)
        ref.updateData([
            "userID": userID,
            "prayStartDate": prayStartDate,
            "prayerList": prayerList
        ])
    } // This function enables the user to update user documentation with userID, prayer start date, and prayer list.
    
    //Adding a friend - this updates the historical prayer feed
    func updateFriendHistoricalPrayersIntoFeed(userID: String, person: Person) async throws {
        //In this scenario, userID is the userID of the person retrieving data from the 'person'.
        do {
            //user is retrieving prayer requests of the friend: person.userID and person: person.
            let prayerRequests = try await PrayerRequestHelper().getPrayerRequests(userID: person.userID, person: person, status: "Current")
            
            print(prayerRequests.description)
            //for each prayer request, user is taking the friend's prayer request and updating them to their own feed. The user becomes the 'friend' of the person.
            for prayer in prayerRequests {
                PrayerRequestHelper().updatePrayerFeed(prayerRequest: prayer, person: person, friendID: userID, updateFriend: true)
                print(prayer.id)
            }
        } catch {
            throw PrayerPersonRetrievalError.errorRetrievingFromFirebase
        }
    }
    
    // Account settings
    func deletePerson(userID: String, friendsList: [String]) async throws {
        Task {
            do {
                // delete from prayer requests list.
                let prayerRequests = try await db.collection("prayerRequests").whereField("userID", isEqualTo: userID).getDocuments()
                
                for request in prayerRequests.documents {
                    try await request.reference.delete()
                }
                
                // delete user's feed
                let prayerFeedRef = try await db.collection("prayerFeed").document(userID).collection("prayerRequests").getDocuments()
                for request in prayerFeedRef.documents {
                    try await request.reference.delete()
                }
                
                // delete from friend's feed
                if friendsList.isEmpty == false {
                    for friendID in friendsList {
                        let prayerRequests = try await db.collection("prayerFeed").document(friendID).collection("prayerRequests").whereField("userID", isEqualTo: userID).getDocuments()
                        
                        for request in prayerRequests.documents {
                            try await request.reference.delete()
                        }
                    }
                }
                
                // delete user's info data.
                let userFriendsListRef = try await db.collection("users").document(userID).collection("friendsList").getDocuments()
                for request in userFriendsListRef.documents {
                    try await request.reference.delete()
                }
                
                let userPrayerListRef = try await db.collection("users").document(userID).collection("prayerList").getDocuments()
                for person in userPrayerListRef.documents {
                    for request in try await person.reference.collection("prayerRequests").getDocuments().documents {
                        try await request.reference.delete()
                    }
                }
                
                let ref = db.collection("users").document(userID)
                try await ref.delete()
                
                // remove firebase account
                try await Auth.auth().currentUser?.delete()
                
            } catch {
                throw error
            }
        }}
    
    // Login functions:
    func checkIfUsernameExists(username: String) async -> Bool {
        var check = Bool()
        
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
    } // This function allows you to pass in a username and return a boolean whether the username exists already. For account creation.
    
}
