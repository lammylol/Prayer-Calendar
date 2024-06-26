//
//  EditPrayerRequestForm.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/17/23.
//
// Description: This is the form to edit an existing prayer request.

import SwiftUI

struct PrayerRequestFormView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @Binding var prayerRequest: PrayerRequest
    @State var prayerRequestUpdates: [PrayerRequestUpdate] = []
    @State var showAddUpdateView: Bool = false
    @State private var originalPrivacy: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                if person.userID == userHolder.person.userID { // only if you are the 'owner' of the profile.
                    Section(header: Text("Prayer Request Title")) {
                        ZStack(alignment: .topLeading) {
                            if prayerRequest.prayerRequestTitle.isEmpty {
                                Text("Title")
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            Text(prayerRequest.prayerRequestTitle).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                            TextEditor(text: $prayerRequest.prayerRequestTitle)
                                .offset(x: -5, y: -1)
                            
                        }
                        .padding(.bottom, -4)
                        Picker("Status", selection: $prayerRequest.status) {
                            Text("Current").tag("Current")
                            Text("Answered").tag("Answered")
                            Text("No Longer Needed").tag("No Longer Needed")
                        }
                        HStack {
                            Text("Privacy")
                            Spacer()
                            PrivacyView(person: person, privacySetting: $prayerRequest.privacy)
                        }
                    }
                    Section(header: Text("Edit Prayer Request")) {
                        ZStack(alignment: .topLeading) {
                            if prayerRequest.prayerRequestText.isEmpty {
                                Text("Enter text")
                                    .padding(.leading, 0)
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            NavigationLink(destination: EditPrayerRequestTextView(person: person, prayerRequest: $prayerRequest)) {
                                // Navigation to edit text. Not binding because we want it to only update upon submission.
                                Text(prayerRequest.prayerRequestText)
                            }
                        }
                    }
                    if prayerRequestUpdates.count > 0 {
                        ForEach(prayerRequestUpdates) { update in
                            Section(header: Text("\(update.updateType): \(update.datePosted, style: .date)")) {
                                VStack(alignment: .leading){
                                    NavigationLink(destination: PrayerUpdateView(person: person, prayerRequest: prayerRequest, prayerRequestUpdates: prayerRequestUpdates, update: update)) {
                                        Text(update.prayerUpdateText)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            showAddUpdateView.toggle()
                        }) {Text("Add Update or Testimony")
                            //                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    Section {
                        Button(action: {
                            deletePrayerRequest()
                        }) {Text("Delete Prayer Request")
                            //                                .font(.system(size: 16))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                } else { // if you are not the owner, then you can't edit.
                    Section(header: Text("Title")) {
                        VStack(alignment: .leading) {
                            Text(prayerRequest.prayerRequestTitle)
                        }
                    }
                    Section(header: Text("Prayer Request")) {
                        VStack(alignment: .leading){
                            Text(prayerRequest.prayerRequestText)
                        }
                        Text("Status: \(prayerRequest.status)")
                    }
                    if prayerRequestUpdates.count > 0 {
                        ForEach(prayerRequestUpdates) { update in
                            Section(header: Text("\(update.updateType): \(update.datePosted, style: .date)")) {
                                VStack(alignment: .leading){
                                    Text(update.prayerUpdateText)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .task {
                do {
                    prayerRequest = try await PrayerRequestHelper().getPrayerRequest(prayerRequest: prayerRequest)
                    prayerRequestUpdates = try await PrayerUpdateHelper().getPrayerRequestUpdates(prayerRequest: prayerRequest, person: person)
                    print(prayerRequestUpdates)
                    print("isPinned: " + prayerRequest.isPinned.description)
                    originalPrivacy = prayerRequest.privacy // for catching public to private.
                } catch PrayerRequestRetrievalError.noPrayerRequestID {
                    print("missing prayer request ID for update.")
                } catch {
                    print("error retrieving")
                }
            }
            .sheet(isPresented: $showAddUpdateView, onDismiss: {
                Task {
                    do {
                        prayerRequestUpdates = try await PrayerUpdateHelper().getPrayerRequestUpdates(prayerRequest: prayerRequest, person: person)
                        prayerRequest = try await PrayerRequestHelper().getPrayerRequest(prayerRequest: prayerRequest)
                    } catch {
                        print("error retrieving updates.")
                    }
                }
            }) {
                AddPrayerUpdateView(person: person, prayerRequest: prayerRequest)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if person.userID == userHolder.person.userID { // only if you are the 'owner' of the profile.
                        Button(action: {
                            updatePrayerRequest(prayerRequest: prayerRequest)
                        }) {
                            Text("Save")
                                .offset(x: -4)
                                .font(.system(size: 14))
                                .padding([.leading, .trailing], 5)
                                .bold()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blue)
                        )
                        .foregroundStyle(.white)
                    }
                }
            }
//                .navigationBarBackButtonHidden(true)
            .navigationTitle("Prayer Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    func updatePrayerRequest(prayerRequest: PrayerRequest) {
        
        // Function to catch if privacy was changed from public to private.
        let newPrivacy = prayerRequest.privacy
        if originalPrivacy != "private" && newPrivacy == "private" {
            PrayerRequestHelper().publicToPrivate(prayerRequest: prayerRequest, friendsList: userHolder.friendsList)
        } // if the privacy has changed from public to private, delete it from friends' feeds.
        
        PrayerRequestHelper().editPrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)
        self.prayerRequest = prayerRequest
        
        print("Saved")
        dismiss()
    }
    
    func deletePrayerRequest() {
        PrayerRequestHelper().deletePrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)
        userHolder.refresh = true
        
        print("Deleted")
        dismiss()
    }
}

struct EditPrayerRequestTextView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @Binding var prayerRequest: PrayerRequest
    @State private var prayerRequestOriginalText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Prayer Request")) {
                    ZStack(alignment: .topLeading) {
                        if prayerRequest.prayerRequestText.isEmpty {
                            Text("Enter text")
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        Text(prayerRequest.prayerRequestText).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                            .padding([.top, .bottom], 5)
                        TextEditor(text: $prayerRequest.prayerRequestText)
                            .offset(x: -5)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
//                    dismiss()
                    updatePrayerRequest(prayerRequestVar: prayerRequest)
                }) {
                    Text("Update")
                        .offset(x: -4)
                        .font(.system(size: 14))
                        .padding([.leading, .trailing], 5)
                        .bold()
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.blue)
                )
                .foregroundStyle(.white)
            }
        }
        .navigationTitle("Edit Prayer Request")
        .navigationBarTitleDisplayMode(.inline)
    }
                
    func updatePrayerRequest(prayerRequestVar: PrayerRequest) {
        PrayerRequestHelper().editPrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)
        print("Saved")
        dismiss()
    }
}

//#Preview {
//    PrayerRequestFormView(person: Person(username: ""), prayerRequest: PrayerRequest.preview)
//        .environment(UserProfileHolder())
//}
