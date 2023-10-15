//
//  PrayerNameInputView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/2/23.
//

import SwiftUI
import SwiftData

struct PrayerNameInputView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(DataHolder.self) var dataHolder
 
//    @Bindable var userProfile: UserPrayerProfile

    @State var prayStartDate: Date = Date()
    @State var username: String = ""
    @State var date: Date = Date()
    @State var prayerListString: String = ""
    @State var saved: String = ""
    
    var body: some View {
        @Bindable var dataHolder = dataHolder
        NavigationStack {
            VStack{
                DatePicker(
                    "Start Date",
                    selection: $prayStartDate,
                    displayedComponents: [.date]
                )
                .padding([.leading, .trailing], 90)
                Divider()
                TextEditor(text: $prayerListString)
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
                    Button(action: {submitList(inputText: prayerListString)}) {
                        Text("Save")
                    }
                }
            }
    }
    }
    
    func submitList(inputText: String) {
//        let inputList = inputText.split(separator: "\n").map(String.init)
//        dataHolder.prayerList = inputList.joined(separator: "\n")
        dataHolder.prayerList = inputText
        dataHolder.prayStartDate = prayStartDate
        print(dataHolder.prayerList)
        saved = "Saved"
        dismiss()
    }
    
//    func passData(username: String, date: Date, prayStartDate: Date, prayerListString: String) {
//        let userData = UserPrayerProfile(username: username, date: date, prayStartDate: prayStartDate, prayerListString: prayerListString)
//        modelContext.insert(userData)
//        try! modelContext.save()
//    }
                           
}

struct PrayerNameInputView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerNameInputView()
    }
}
