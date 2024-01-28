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
    
    var person: PrayerPerson
    @State var datePosted = Date()
    @State var status: String = "Current"
    @State var prayerRequestText: String = ""
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
        PrayerRequestHelper().addPrayerRequest(userID: userHolder.person.userID, person: person, prayerRequestText: prayerRequestText, priority: priority, userHolder: userHolder)

        print("Saved")
        dismiss()
    }
}

#Preview {
    SubmitPrayerRequestForm(person: PrayerPerson(username: "lammylol"))
        .environment(UserProfileHolder())
}
