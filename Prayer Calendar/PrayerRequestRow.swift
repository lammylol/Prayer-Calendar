//
//  PrayerRequestRows.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//
// Description: This captures the layout of what each row in the prayer request list looks like.

import SwiftUI

struct PrayerRequestRow: View {
    let prayerRequest: PrayerRequest
    var profileOrPrayerFeed = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if profileOrPrayerFeed == "feed" {
                HStack() {
                    Text(prayerRequest.firstName + " " + prayerRequest.lastName)
                    Text("status: ")+Text(prayerRequest.status.capitalized).bold()
                    Spacer()
                    Text(prayerRequest.date, style: .date)
                    Text(prayerRequest.date, style: .time)
                }.font(.system(size: 12))
            } else {
                HStack() {
                    Text("status: ")+Text(prayerRequest.status.capitalized).bold()+Text(", priority: ")+Text(prayerRequest.priority.capitalized).bold()
                    Spacer()
                    Text(prayerRequest.date, style: .date)
                    Text(prayerRequest.date, style: .time)
                }.font(.system(size: 12))
                HStack() {
            }
                Spacer()
            }

            Text("\(prayerRequest.prayerRequestText)")

            Divider()
        }
//        .background(Color.gray.opacity(0.05))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .multilineTextAlignment(.leading)
        .padding([.leading, .trailing], 20)
    }
}

#Preview {
    PrayerRequestRow(prayerRequest: PrayerRequest(userID: "", date: Date(), prayerRequestText: "Prayers for this text to look beautiful. Prayers for this text to look beautiful.", status: "Current", firstName: "Matt", lastName: "Lam", priority: "high"))
}
