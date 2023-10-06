//
//  PrayerNameInputView.swift
//  PrayerCalendarSwift
//
//  Created by Matt Lam on 10/2/23.
//

import SwiftUI

struct PrayerNameInputView: View {
    
    @EnvironmentObject var dataHolder: DataHolder
    @State var inputList: String// = ""
    @State var saved = ""
    @State var prayStartDate: Date = Date()
    
//    init(inputList: String, prayStartDate: Date) {
//        self.prayStartDate = dataHolder.prayStartDate
//        self.inputList = dataHolder.prayerListString
//    }

    var body: some View {
        NavigationStack {
            Text("")
                .toolbar() {
                }
                .navigationTitle("Input Your Prayer List")
                .navigationBarTitleDisplayMode(.inline)
            DatePicker(
                "Start Date",
                selection: $prayStartDate,
                displayedComponents: [.date]
            )
            .padding([.leading, .trailing], 90)
            Divider()
            TextEditor(text: $inputList)
//                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 20)
                .padding([.top], 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Spacer()
            Button(action: {submitList(inputText: inputList)}) {
                Text("Save")
            }
            Spacer()
            Text(saved)
                .font(Font.system(size: 12))
            Spacer()
        }
    }
    
    func submitList(inputText: String) {
        let inputList = inputText.split(separator: "\n").map(String.init)
        dataHolder.prayerList = inputList
        dataHolder.prayerListString = dataHolder.prayerList.joined(separator: "\n")
        dataHolder.prayStartDate = prayStartDate
        print(dataHolder.prayerList)
        saved = "Saved"
    }
                           
//    func showsDatePicker() {
//            DatePicker(
//               "hello",
//               selection: $prayStartDate,
//               displayedComponents: [.date]
//           )
//           .datePickerStyle(.graphical)
//        dataHolder.prayStartDate = prayStartDate
//   }
}

struct PrayerNameInputView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerNameInputView(inputList: "Matt, Esther", prayStartDate: Date())
            .environmentObject(DataHolder())
    }
}
