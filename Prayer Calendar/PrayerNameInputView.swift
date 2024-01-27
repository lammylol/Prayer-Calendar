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
            .navigationTitle("List of People to Pray For")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                if self.isFocused == true {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                            prayerList = dataHolder.prayerList
                            prayStartDate = dataHolder.prayStartDate
                            self.isFocused = false
                            saved = ""
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            submitList(inputText: prayerList)
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
    
    func submitList(inputText: String) {
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
            
            for person in prayerNames {
                if person.username != "" {
                    let personID = await PrayerPersonHelper().retrieveUserInfoFromUsername(person: person, userHolder: userHolder).userID
                    let refFriends = db.collection("users").document(personID).collection("friendsList").document(userHolder.person.userID)
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
                           
}

struct PrayerNameInputView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerNameInputView(dataHolder: PrayerListHolder())
            .environment(PrayerListHolder())
            .environment(UserProfileHolder())
    }
}
