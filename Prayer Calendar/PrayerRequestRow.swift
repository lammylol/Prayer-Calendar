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
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text(prayerRequest.firstName + " " + prayerRequest.lastName)
            Text(prayerRequest.date, style: .date).italic()
            Text("\(prayerRequest.status): \(prayerRequest.prayerRequestText)")
            Text("Priority: \(prayerRequest.priority)")
            Divider()
        }
//        .background(Color.gray.opacity(0.05))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .multilineTextAlignment(.leading)
        .padding([.leading, .trailing], 20)
    }
}

#Preview {
    PrayerRequestRow(prayerRequest: PrayerRequest(userID: "", date: Date(), prayerRequestText: "Hello jklasjdksjdklsjdklsajdklasjdkalsdjkalsdjlasjdaksd", status: "Current", firstName: "Matt", lastName: "Lam", priority: "high"))
}
