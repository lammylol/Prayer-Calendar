//
//  PrayerNameInputView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/2/23.
//

import SwiftUI
import Observation
import FirebaseFirestore

struct PrayerNameInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(UserProfileHolder.self) var userHolder
    
    @Bindable var dataHolder: PrayerListHolder // This holds things necessary for prayer list.

    @State var prayStartDate: Date = Date()
    @State var prayerList: String = ""
    @State var date: Date = Date()
    @State var saved: String = ""
    @FocusState private var isFocused: Bool
    
    init(dataHolder: PrayerListHolder) {
        self.dataHolder = dataHolder
        _prayerList = State(initialValue: dataHolder.prayerList)
        _prayStartDate = State(initialValue: dataHolder.prayStartDate)
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                DatePicker(
                "Start Date",
                selection: $prayStartDate,
                displayedComponents: [.date]
                )
                .padding([.leading, .trailing], 85)
                
                Divider()
                Text("Input your list below. To link to an active profile, paste a semicolon followed by the person's username.\n\nex. Matt; matt12345")
                    .italic()
                    .padding(.all, 10)
                    .font(.system(size: 14))
                TextEditor(text: $prayerList)
                    .padding([.leading, .trailing], 20)
                    .padding([.top], 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .focused($isFocused)
                Spacer()
                Text(savedText())
                    .font(Font.system(size: 12))
                Spacer()
            }
            .navigationTitle("Prayer Calendar List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if self.isFocused == true {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            do { 
                                try submitList(inputText: prayerList, userID: userHolder.person.userID, existingInput: dataHolder.prayerList)
                            } catch PrayerPersonRetrievalError.incorrectUsername {
                                saved = "Invalid username entered"
                            } catch {
                                saved = error.localizedDescription
                            }
                        }) {
                            Text("Save")
                                .offset(x: -4)
                                .font(.system(size: 14))
                                .padding([.leading, .trailing], 5)
                                .bold()
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                        }
                        .foregroundStyle(.white)
                    }
                }
            }
    }
    }
    
    //function to submit prayer list to firestore. This will update users' prayer list for retrieval into prayer calendar and it will also tie a friend to this user if the username is linked.
    func submitList(inputText: String, userID: String, existingInput: String) throws {
        let inputList = inputText.split(separator: "\n").map(String.init)

        let db = Firestore.firestore()
        
        //Create user data in personal doc.
        Task {
            let ref = db.collection("users").document(userHolder.person.userID)
            
            ref.updateData([
                "userID": userHolder.person.userID,
                "prayStartDate": prayStartDate,
                "prayerList": prayerList
            ])
        }
        
        //Add user as friend to the friend's list.
        Task {
            print("Prayer List Old: " + dataHolder.prayerList)
            print("Prayer List New: " + inputText)

            let prayerNamesOld = PrayerPersonHelper().retrievePrayerPersonArray(prayerList: existingInput).map {
                if $0.username == "" {
                    $0.firstName + "/" + $0.lastName
                } else {
                    $0.username
                }
            } // reference to initial state of prayer list
            let prayerNamesNew = PrayerPersonHelper().retrievePrayerPersonArray(prayerList: inputText).map {
                if $0.username == "" {
                    $0.firstName + "/" + $0.lastName
                } else {
                    $0.username
                }
            } // reference to new state of prayer list.
            var linkedFriends = []
            
            print(prayerNamesOld)
            print(prayerNamesNew)
            
            let insertions = Array(Set(prayerNamesNew).subtracting(Set(prayerNamesOld)))
            let removals = Array(Set(prayerNamesOld).subtracting(Set(prayerNamesNew)))
            
            print("insertions: ")
            print(insertions)
            print("removals: ")
            print(removals)
            
            // for each person in prayerList who has a username (aka a linked account), check if the user already exists in the prayerList person's friendsList. If not, add their name and update all historical prayer feeds as well.
            
            for usernameOrName in insertions {
                if usernameOrName.contains("/") == false { // This checks if the person is a linked account or not. If it was linked, usernameOrName would be a username. Usernames cannot have special characters in them.
                    do { 
                        let person = try await PrayerPersonHelper().retrieveUserInfoFromUsername(person: Person(username: usernameOrName), userHolder: userHolder) // retrieve the "person" structure based on their username. Will return back user info.
                        
                        guard person.userID != "" else {
                            throw PrayerPersonRetrievalError.incorrectUsername
                        }
                        // Update the friends list of the person who you have now added to your list. Their friends list is updated, so that when they post, it will add to your feed. At the same time, any of their existing requests will also populate into your feed.
                        let refFriends = db.collection("users").document(person.userID).collection("friendsList").document(userHolder.person.userID)
                        
                        do {
                            if try await refFriends.getDocument().exists == false {
                                try await refFriends.setData([
                                    "username": userHolder.person.username
                                ])
                                await updateFriendHistoricalPrayersIntoFeed(userID: userID, person: person)
                            }
                        } catch {
                            print("error update friend: username")
                        }
                        
                        linkedFriends.append(person.firstName + " " + person.lastName) // for printing purposes.
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } else { //else is for any names you have added which do not have a username; under your account and not linked.
                    
                    // Fetch all historical prayers from that person into your feed, noting that these do not have a linked username. So you need to pass in your own userID into that person for the function to retrieve out of your prayerFeed/youruserID.
                    await updateFriendHistoricalPrayersIntoFeed(userID: userID, person: Person(userID: userID, firstName: String(usernameOrName.split(separator: "/").first ?? ""), lastName: String(usernameOrName.split(separator: "/").last ?? "")))
                }
            }
            for usernameOrName in removals {
                if usernameOrName.contains("/") == false { // This checks if the person is a linked account or not. If it was linked, usernameOrName would be a username. Usernames cannot have special characters in them.
                    
                    let person = try await PrayerPersonHelper().retrieveUserInfoFromUsername(person: Person(username: usernameOrName), userHolder: userHolder) // retrieve the "person" structure based on their username. Will return back user info.
                    
                    guard person.userID != "" else {
                        throw PrayerPersonRetrievalError.incorrectUsername
                    }
                    // Update the friends list of the person who you have now removed from your list. Their friends list is updated, so that when they post, it will not add to your feed.
                    let refFriends = db.collection("users").document(person.userID).collection("friendsList").document(userHolder.person.userID)
                    try await refFriends.delete()
                    
                    // Update your prayer feed to remove that person's prayer requests from your current feed.
                    let refDelete = try await db.collection("prayerFeed").document(userID).collection("prayerRequests").whereField("userID", isEqualTo: person.userID).getDocuments()
                    for document in refDelete.documents {
                        try await document.reference.delete()
                    }
                } else { //else is for any names you have added which do not have a username; under your account and not linked.
                    
                    // Fetch all prayer requests with that person's first name and last name, so they are removed from your feed.
                    let refDelete = try await db.collection("prayerFeed").document(userHolder.person.userID).collection("prayerRequests")
                        .whereField("firstName", isEqualTo: String(usernameOrName.split(separator: "/").first ?? ""))
                        .whereField("lastName", isEqualTo: String(usernameOrName.split(separator: "/").last ?? ""))
                        .getDocuments()
                    
                    for document in refDelete.documents {
                        try await document.reference.delete()
                    }
                }
            }
            print("Profiles linked: \(linkedFriends)")
        }
        
        //reset local dataHolder
        dataHolder.prayerList = inputList.joined(separator: "\n")
        dataHolder.prayStartDate = prayStartDate
        
        saved = "Saved"
        self.isFocused = false // removes focus so keyboard disappears
        dismiss() //dismiss view
    }
    
    //Function to changed "saved" text. When user saves textEditor, saved will appear until the user clicks back into textEditor, then the words "saved" should disappear. This will also occur when cancel is selected.
    func savedText() -> String {
        if self.isFocused == true {
            return ""
        } else {
            return saved
        }
    }
    
    //Adding a friend - this updates the historical prayer feed
    func updateFriendHistoricalPrayersIntoFeed(userID: String, person: Person) async {
        //In this scenario, userID is the userID of the person retrieving data from the 'person'.
            Task{
                do {
                    //user is retrieving prayer requests of the friend: person.userID and person: person.
                    let prayerRequests = try await PrayerRequestHelper().getPrayerRequests(userID: person.userID, person: person)
                    
                    //for each prayer request, user is taking the friend's prayer request and updating them to their own feed. The user becomes the 'friend' of the person.
                    for prayer in prayerRequests {
                        PrayerRequestHelper().updatePrayerFeed(prayerRequest: prayer, person: person, friendID: userID, updateFriend: true)
                    }
//                    print(prayerRequests)
                } catch {
                    print(error)
                }
            }
    }
}

struct PrayerNameInputView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerNameInputView(dataHolder: PrayerListHolder())
            .environment(PrayerListHolder())
            .environment(UserProfileHolder())
    }
}
