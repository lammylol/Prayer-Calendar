//
//  SubmitPrayerRequestForm.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/14/23.
//
// This is the form for a user to submit a new prayer request

import SwiftUI
import FirebaseFirestore

struct SubmitPrayerRequestForm: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.dismiss) var dismiss
    
    var person: Person
    @State var datePosted = Date()
    @State var status: String = "Current"
    @State var prayerRequestText: String = ""
    @State var prayerRequestTitle: String = ""
    @State private var priority = "low"
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Share a Prayer Request")) {
                    Picker("Priority", selection: $priority) {
                        Text("low").tag("low")
                        Text("med").tag("med")
                        Text("high").tag("high")
                    }
                    ZStack(alignment: .topLeading) {
                        if prayerRequestTitle.isEmpty {
                            Text("Title")
                                .padding(.leading, 0)
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        
                        TextEditor(text: $prayerRequestTitle)
                            .frame(height: 35)
                            .offset(x: -5, y: -1)
                    }
                    ZStack(alignment: .topLeading) {
                        if prayerRequestText.isEmpty {
                            Text("Enter text: suggestion - write your request in the form of a prayer, so that readers can join with you in prayer as they read it.")
                                .padding(.leading, 0)
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        
                        TextEditor(text: $prayerRequestText)
                            .frame(height: 300)
                            .offset(x: -5)
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
                    Button(action: {submitList()}) {
                        Text("Post")
                            .offset(x: -4)
                            .font(.system(size: 16))
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
            .navigationBarBackButtonHidden(true)
        }
    }
        
    func submitList() {
        PrayerRequestHelper().createPrayerRequest(userID: userHolder.person.userID, datePosted: Date(), person: person, prayerRequestText: prayerRequestText, prayerRequestTitle: prayerRequestTitle, priority: priority, friendsList: userHolder.friendsList)

        print("Saved")
        dismiss()
    }
}

#Preview {
    SubmitPrayerRequestForm(person: Person(username: "lammylol"))
        .environment(UserProfileHolder())
}
