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
    @State var prayerRequest: PrayerRequest
    @State var prayerRequestUpdates: [PrayerRequestUpdate] = []
    @State var showAddUpdateView: Bool = false
    
    var body: some View {
        NavigationStack {
                Form {
                    Section(header: Text("Prayer Request title")) {
                        ZStack(alignment: .topLeading) {
                            if prayerRequest.prayerRequestTitle.isEmpty {
                                Text("Title")
                                    .padding(.leading, 0)
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            Text(prayerRequest.prayerRequestTitle).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                            TextEditor(text: $prayerRequest.prayerRequestTitle)
                                .offset(x: -5, y: -1)

                        }
                        Picker("Priority", selection: $prayerRequest.priority) {
                            Text("low").tag("low")
                            Text("med").tag("med")
                            Text("high").tag("high")
                        }
                        Picker("Status", selection: $prayerRequest.status) {
                            Text("Current").tag("Current")
                            Text("Answered").tag("Answered")
                            Text("No Longer Needed").tag("No Longer Needed")
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
                            NavigationLink(destination: EditPrayerRequestTextView(person: person, prayerRequest: prayerRequest)) {
                                Text(prayerRequest.prayerRequestText)
                            }
                        }
                    }
                    
                    if prayerRequestUpdates.count > 0 {
                        ForEach(prayerRequestUpdates) { update in
                            Section(header: Text("Update: \(update.datePosted, style: .date)")) {
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
                        }) {Text("Add Update")
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
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .task {
                    do {
                        prayerRequest.prayerRequestText = try await PrayerRequestHelper().getPrayerRequest(prayerRequest: prayerRequest).prayerRequestText
                        prayerRequestUpdates = try await PrayerUpdateHelper().getPrayerRequestUpdates(prayerRequest: prayerRequest, person: person)
                        print(prayerRequestUpdates)
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
                        } catch {
                            print("error retrieving updates.")
                        }
                    }
                }) {
                    AddPrayerUpdateView(person: person, prayerRequest: prayerRequest)
                }
//                    if person.username == "" || (person.userID == userHolder.person.userID) {
//                        ToolbarItemGroup(placement: .bottomBar) {
//                            Button(action: {deletePrayerRequest()}) {
//                                Text("Delete Prayer Request")
//                                    .font(.system(size: 14))
//                                    .padding([.leading, .trailing], 5)
//                            }
//                            .background(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .fill(.red)
//                            )
//                            .foregroundStyle(.white)
//                        }
//                    }
//                .navigationBarBackButtonHidden(true)
                .navigationTitle("Prayer Request")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
        }
    }
    
    func deletePrayerRequest() {
        PrayerRequestHelper().deletePrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)

        print("Deleted")
        dismiss()
    }
}

struct EditPrayerRequestTextView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @State var prayerRequest: PrayerRequest
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Prayer Request")) {
                    ZStack(alignment: .topLeading) {
                        if prayerRequest.prayerRequestText.isEmpty {
                            Text("Enter text")
                                .padding(.leading, 0)
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
                    updatePrayerRequest(prayerRequestVar: prayerRequest)
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
        .navigationTitle("Edit Prayer Request")
        .navigationBarTitleDisplayMode(.inline)
    }
                
    func updatePrayerRequest(prayerRequestVar: PrayerRequest) {
        PrayerRequestHelper().editPrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)
        
        print("Saved")
        dismiss()
    }
}

struct PrayerUpdateView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @State var prayerRequest: PrayerRequest
    @State var prayerRequestUpdates: [PrayerRequestUpdate] = []
    @State var update: PrayerRequestUpdate
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Date Posted: \(update.datePosted.formatted(.dateTime))")) {
                    ZStack(alignment: .topLeading) {
                        if update.prayerUpdateText == "" {
                            Text("Text")
                                .padding(.leading, 0)
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        Text(update.prayerUpdateText).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                        TextEditor(text: $update.prayerUpdateText)
                            .offset(x: -5, y: -1)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    updatePrayerUpdate()
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
            
            if person.username == "" || (person.userID == userHolder.person.userID) {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {deleteUpdate()}) {
                        Text("Delete Update")
                            .font(.system(size: 14))
                            .padding([.leading, .trailing], 5)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red)
                    )
                    .foregroundStyle(.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Prayer Update")
    }
    
    func deleteUpdate() {
        var updates = prayerRequestUpdates.sorted(by: {$1.datePosted > $0.datePosted})
        print("before:")
        print(updates)
        updates.removeAll(where: {$0.id == update.id}) // must come first in order to make sure the prayer request last date posted can be factored correctly.
        print("after:")
        print(updates)
        PrayerUpdateHelper().deletePrayerUpdate(prayerRequest: prayerRequest, prayerRequestUpdate: update, updatesArray: updates, person: person, friendsList: userHolder.friendsList)

        print("Deleted")
        dismiss()
    }
    
    func updatePrayerUpdate() {
        PrayerUpdateHelper().editPrayerUpdate(prayerRequest: prayerRequest, prayerRequestUpdate: update, person: person, friendsList: userHolder.friendsList, updatesArray: prayerRequestUpdates)
        print("Saved")
        dismiss()
    }
    
}

struct AddPrayerUpdateView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @State var prayerRequest: PrayerRequest
    @State var update: PrayerRequestUpdate = PrayerRequestUpdate(datePosted: Date(), prayerUpdateText: "")
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add Update to Prayer Request")) {
                    ZStack(alignment: .topLeading) {
                        if update.prayerUpdateText == "" {
                            Text("Text")
                                .padding(.leading, 0)
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        Text(update.prayerUpdateText).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                        TextEditor(text: $update.prayerUpdateText)
                            .offset(x: -5, y: -1)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {self.addUpdate()}) {
                        Text("Add")
                            .offset(x: -4)
                            .font(.system(size: 14))
                            .padding([.leading, .trailing], 10)
                            .bold()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                    )
                    .foregroundStyle(.white)
                }
            }
            .navigationTitle("Prayer Update")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addUpdate() {
        PrayerUpdateHelper().addPrayerRequestUpdate(datePosted: Date(), prayerRequest: prayerRequest, prayerRequestUpdate: update, person: person, friendsList: userHolder.friendsList)
        print("Saved")
        dismiss()
    }
}

#Preview {
    PrayerRequestFormView(person: Person(username: ""), prayerRequest: PrayerRequest.preview)
        .environment(UserProfileHolder())
}
