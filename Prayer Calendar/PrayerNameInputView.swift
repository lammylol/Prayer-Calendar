//
//  PrayerNameInputView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/2/23.
//

import SwiftUI
import SwiftData

struct PrayerNameInputView: View {
    
    @EnvironmentObject var dataHolder: DataHolder
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @Query private var profiles: [UserPrayerProfile]
    @Bindable var userProfile: UserPrayerProfile
    let username: String = ""

    @Query(filter: #Predicate<UserPrayerProfile> {$0.username == "Matt"}) var userprofile: [UserPrayerProfile]
    
    @State var inputList: String
    @State var saved = ""
    @State var prayStartDate: Date = Date()
//    @State var username: String = ""

    var body: some View {
        NavigationStack {
            VStack{
                DatePicker(
                    "Start Date",
                    selection: $prayStartDate,
                    displayedComponents: [.date]
                )
                .padding([.leading, .trailing], 90)
                Divider()
                TextEditor(text: $userProfile.prayerListString)
                    .padding([.leading, .trailing], 20)
                    .padding([.top], 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
                Text(saved)
                    .font(Font.system(size: 12))
                Spacer()
            }
            .navigationTitle("Input Your Prayer List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {submitList(inputText: inputList)}) {
                        Text("Save")
                    }
                }
            }
    }
    }
    
    func submitList(inputText: String) {
        let inputList = inputText.split(separator: "\n").map(String.init)
        dataHolder.prayerList = inputList
        dataHolder.prayerListString = dataHolder.prayerList.joined(separator: "\n")
        dataHolder.prayStartDate = prayStartDate
        print(dataHolder.prayerList)
        passData(username: dataHolder.username, prayStartDate: prayStartDate, prayerListString: inputList.joined(separator: "\n"))
        saved = "Saved"
        dismiss()
    }
    
    func submitList2(inputText: String) {
        let inputList = inputText.split(separator: "\n").map(String.init)
        dataHolder.prayerList = inputList
        dataHolder.prayerListString = dataHolder.prayerList.joined(separator: "\n")
        dataHolder.prayStartDate = prayStartDate
        print(dataHolder.prayerList)
        passData(username: dataHolder.username, prayStartDate: prayStartDate, prayerListString: inputList.joined(separator: "\n"))
        saved = "Saved"
        dismiss()
    }
    
    func passData(username: String, prayStartDate: Date, prayerListString: String) {
        let userData = UserPrayerProfile(username: username, prayStartDate: prayStartDate, prayerListString: prayerListString)
        context.insert(userData)
        try! context.save()
    }
                           
}

struct PrayerNameInputView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerNameInputView(inputList: "Matt-Usr\nEsther-Usr", prayStartDate: Date(),, username: "Matt")
            .environmentObject(DataHolder())
    }
}
