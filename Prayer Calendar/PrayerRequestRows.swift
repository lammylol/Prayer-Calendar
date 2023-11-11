//
//  PrayerRequestRows.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import SwiftUI

struct PrayerRequestRow: View {
    let prayerRequest: PrayerRequest
    
    var body: some View {
        VStack {
            Text(prayerRequest.username)
            Text(prayerRequest.date, style: .date)
            Text(prayerRequest.prayerRequestText)
            Text(prayerRequest.status)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 20)
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    PrayerRequestRow(prayerRequest: PrayerRequest(username: "matt", date: Date(), prayerRequestText: "Hello", status: "Current"))
}
