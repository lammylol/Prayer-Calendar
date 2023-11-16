//
//  SubmitPrayerRequestForm.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/14/23.
//

import SwiftUI
import FirebaseFirestore

struct SubmitPrayerRequestForm: View {
    @Environment(PrayerList.self) var dataHolder
    @Environment(\.dismiss) var dismiss
    
    var firstName = "abc"
    var lastName = "test"
    @State var datePosted = Date()
    @State var status: String = "Current"
    @State var prayerRequestText: String = ""
    @State private var priority = "3"
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Share a Prayer Request")) {
                    Picker("Priority", selection: $priority) {
                        Text("low").tag("1")
                        Text("med").tag("2")
                        Text("high").tag("3)")
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
        PrayerRequestViewModel().addPrayerRequest(username: dataHolder.email, firstName: firstName, lastName: lastName, prayerRequestText: prayerRequestText)

        print("Saved")
        dismiss()
    }
}

#Preview {
    SubmitPrayerRequestForm()
        .environment(PrayerList())
}
