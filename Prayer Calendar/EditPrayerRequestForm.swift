//
//  EditPrayerRequestForm.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/17/23.
//
// Description: This is the form to edit an existing prayer request.

import SwiftUI

struct EditPrayerRequestForm: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @State var prayerRequest: PrayerRequest
    
    var body: some View {
        NavigationView{
            VStack{
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
                    }
                    Section(header: Text("Edit Prayer Request")) {
                        ZStack(alignment: .topLeading) {
                            if prayerRequest.prayerRequestText.isEmpty {
                                Text("Enter text")
                                    .padding(.leading, 0)
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            Text(prayerRequest.prayerRequestText).foregroundColor(Color.clear)//this is a swift workaround to dynamically expand textEditor.
                            TextEditor(text: $prayerRequest.prayerRequestText)
                                .offset(x: -5)
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
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .onAppear() {
                    prayerRequest = PrayerRequest(id: prayerRequest.id, userID: prayerRequest.userID, username: prayerRequest.username, date: prayerRequest.date, prayerRequestText: prayerRequest.prayerRequestText, status: prayerRequest.status, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName, priority: prayerRequest.priority, prayerRequestTitle: prayerRequest.prayerRequestTitle, latestUpdateText: prayerRequest.latestUpdateText, latestUpdateDatePosted: prayerRequest.latestUpdateDatePosted)
                    
                    print(prayerRequest.date)
                }
                
                //if list of prayer request updates >0, show list.
                
//                Button(action: {PrayerRequestHelper().addPrayerRequestUpdate(datePosted: Date(), prayerRequest: prayerRequest, prayerRequestUpdate: prayerRequestUpdate, person: person, friendsList: userHolder.friendsList)}) {
//                    Text("Add Prayer Update")
//                }
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
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
                if person.username == "" || (person.userID == userHolder.person.userID) {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {deletePrayerRequest()}) {
                            Text("Delete Prayer Request")
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func updatePrayerRequest(prayerRequestVar: PrayerRequest) {
        PrayerRequestHelper().editPrayerRequest(prayerRequest: prayerRequestVar, person: person, friendsList: userHolder.friendsList)

        print("Saved")
        dismiss()
    }
    
    func deletePrayerRequest() {
        PrayerRequestHelper().deletePrayerRequest(prayerRequest: prayerRequest, person: person, friendsList: userHolder.friendsList)

        print("Deleted")
        dismiss()
    }
}

#Preview {
    EditPrayerRequestForm(person: Person(username: ""), prayerRequest: PrayerRequest.preview)
        .environment(UserProfileHolder())
}
