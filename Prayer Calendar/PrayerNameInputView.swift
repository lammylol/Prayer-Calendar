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
    
    @Bindable var dataHolder: PrayerListHolder

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
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Cancel") {
//                            dismiss()
//                            prayerList = dataHolder.prayerList
//                            prayStartDate = dataHolder.prayStartDate
//                            self.isFocused = false
//                            saved = ""
//                        }
//                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            submitList(inputText: prayerList, userID: userHolder.person.userID)
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
    func submitList(inputText: String, userID: String) {
        let inputList = inputText.split(separator: "\n").map(String.init)
        dataHolder.prayerList = inputList.joined(separator: "\n")
        dataHolder.prayStartDate = prayStartDate

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
            let prayerNames = PrayerPersonHelper().retrievePrayerPersonArray(prayerList: prayerList)
            
            var linkedFriends = []
            
            // for each person in prayerList who has a username (aka a linked account), check if the user already exists in the prayerList person's friendsList. If not, add their name and update all historical prayer feeds as well.
            for person in prayerNames {
                if person.username != "" {
                    let personID = await PrayerPersonHelper().retrieveUserInfoFromUsername(person: person, userHolder: userHolder).userID
                    
                    let refFriends = db.collection("users").document(personID).collection("friendsList").document(userHolder.person.userID)
                    
                    do {
                        if try await refFriends.getDocument().exists == false {
                            try await refFriends.setData([
                                "username": person.username
                            ])
                            await updateFriendHistoricalPrayersIntoFeed(userID: userID, person: person)
                        }
                    } catch {
                        print("error update friend: username")
                    }
                    
                    linkedFriends.append(person.firstName + " " + person.lastName)
                }
            }
            print("Profiles linked: \(linkedFriends)")
        }
        
        saved = "Saved"
        self.isFocused = false
        dismiss()
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
    func updateFriendHistoricalPrayersIntoFeed(userID: String, person: PrayerPerson) async {
        //In this scenario, userID is the userID of the person retrieving data from the 'person'.
        do {
            let prayerRequests = try await PrayerRequestHelper().retrievePrayerRequest(userID: person.userID, person: person)
            //user is retrieving prayer requests of the friend: person.userID and person: person.
            
            for prayer in prayerRequests {
                PrayerRequestHelper().updatePrayerFeed(prayerRequest: prayer, person: person, friendID: userID, updateFriend: true)
            }
            //for each prayer request, user is taking the friend's prayer request and updating them to their own feed. The user becomes the 'friend' of the person.
        } catch {
            print("error retrieving and updating prayer requests from new friend.")
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
