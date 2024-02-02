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
    
    var person: PrayerPerson
    @State var prayerRequest: PrayerRequest
    
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Section(header: Text("Share a Prayer Request")) {
                        Picker("Priority", selection: $prayerRequest.priority) {
                            Text("low").tag("low")
                            Text("med").tag("med")
                            Text("high").tag("high")
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if prayerRequest.prayerRequestText.isEmpty {
                                Text("Enter text")
                                    .padding(.leading, 6)
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            TextEditor(text: $prayerRequest.prayerRequestText)
                                .frame(height: 300)
                        }
                    }
                    Section(header: Text("Update Status")) {
                        Picker("Status", selection: $prayerRequest.status) {
                            Text("Current").tag("Current")
                            Text("Answered").tag("Answered")
                            Text("No Longer Needed").tag("No Longer Needed")
                        }
                    }
                }
                .onAppear() {
                    prayerRequest = PrayerRequest(id: prayerRequest.id, userID: prayerRequest.userID, username: prayerRequest.username, date: prayerRequest.date, prayerRequestText: prayerRequest.prayerRequestText, status: prayerRequest.status, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName, priority: prayerRequest.priority)
                    
                    print(prayerRequest.date)
                }
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
        PrayerRequestHelper().updatePrayerRequest(prayerRequest: prayerRequestVar, person: person, friendsList: userHolder.friendsList)

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
    EditPrayerRequestForm(person: PrayerPerson(username: ""), prayerRequest: PrayerRequest.preview)
        .environment(UserProfileHolder())
}
