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
    @State private var privacy: String = "public"
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Share a Prayer Request")) {
                    ZStack(alignment: .topLeading) {
                        if prayerRequestTitle.isEmpty {
                            Text("Title")
                                .offset(x: 0, y: 8)
                                .foregroundStyle(Color.gray)
                        }
                        TextEditor(text: $prayerRequestTitle)
                            .frame(minHeight: 38)
                            .offset(x: -5, y: -1)
                    }
                    .padding(.bottom, -4)
                    ZStack(alignment: .topLeading) {
                        if prayerRequestText.isEmpty {
                            Text("Enter Text. Consider writing your request in the form of a prayer so that readers can join with you in prayer as they read it.")
                                .padding(.leading, 0)
                                .padding(.top, 8)
                                .foregroundStyle(Color.gray)
                        }
                        
                        TextEditor(text: $prayerRequestText)
                            .frame(height: 300)
                            .offset(x: -5)
                    }
                }
                HStack {
                    Text("Privacy")
                    Spacer()
                    PrivacyView(person: person, privacySetting: $privacy)
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
        ProfilePrayerRequestHelper().createPrayerRequest(
            userID: userHolder.person.userID,
            datePosted: Date(),
            person: person,
            prayerRequestText: prayerRequestText,
            prayerRequestTitle: prayerRequestTitle,
            privacy: privacy,
            friendsList: userHolder.friendsList)
        userHolder.refresh = true
        print("Saved")
        dismiss()
    }
}

#Preview {
    SubmitPrayerRequestForm(person: Person(username: "lammylol"))
        .environment(UserProfileHolder())
}
