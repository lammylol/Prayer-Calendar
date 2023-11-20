//
//  EditPrayerRequestForm.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/17/23.
//
// Description: This is the form to edit an existing prayer request.

import SwiftUI

struct EditPrayerRequestForm: View {
    @Environment(PrayerListHolder.self) var dataHolder
    @Environment(\.dismiss) var dismiss
    
    let prayerRequest: PrayerRequest
    
    //    var documentID: UUID = UUID()
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var datePosted: Date = Date()
    @State var status: String = "Current"
    @State var prayerRequestText: String = ""
    @State var priority: String = "low"
    
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    Section(header: Text("Share a Prayer Request")) {
                        Picker("Priority", selection: $priority) {
                            Text("low").tag("low")
                            Text("med").tag("med")
                            Text("high").tag("high")
                        }
                        
                        ZStack(alignment: .topLeading) {
                            if prayerRequestText.isEmpty {
                                Text("Enter text")
                                    .padding(.leading, 6)
                                    .padding(.top, 8)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            TextEditor(text: $prayerRequestText)
                                .frame(height: 300)
                        }
                    }
                    Section(header: Text("Update Status")) {
                        Picker("Status", selection: $status) {
                            Text("Current").tag("Current")
                            Text("Answered").tag("Answered")
                            Text("No Longer Needed").tag("No Longer Needed")
                        }
                    }
                }
                .onAppear() {
                    firstName = prayerRequest.firstName
                    lastName = prayerRequest.lastName
                    datePosted = prayerRequest.date
                    prayerRequestText = prayerRequest.prayerRequestText
                    status = prayerRequest.status
                    priority = prayerRequest.priority
                }
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {submitPrayerRequest()}) {
                        Text("Update")
                            .offset(x: -4)
                            .font(.system(size: 14))
                            .padding([.leading, .trailing], 5)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                    )
                    .foregroundStyle(.white)
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {deletePrayerRequest()}) {
                        Text("Delete Prayer Request")
                            .font(.system(size: 14))
                            .padding([.leading, .trailing], 5)
                    }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.gray)
                        )
                        .foregroundStyle(.white)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func submitPrayerRequest() {
        PrayerRequestHelper().updatePrayerRequest(prayerRequest: prayerRequest, username: dataHolder.email)

        print("Saved")
        dismiss()
    }
    
    func deletePrayerRequest() {
        PrayerRequestHelper().deletePrayerRequest(prayerRequest: prayerRequest, username: dataHolder.email)

        print("Deleted")
        dismiss()
    }
}

#Preview {
    EditPrayerRequestForm(prayerRequest: PrayerRequest.preview)
        .environment(PrayerListHolder())
}
