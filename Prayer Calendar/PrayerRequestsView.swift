//
//  PrayerRequestsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/10/23.
//

import SwiftUI

struct PrayerRequestsView: View {
    var prayerRequests: [PrayerRequest]
    
    var body: some View {
//        Text("Hello")
        List {
            ForEach(prayerRequests) {prayer in
                PrayerRequestRow(prayerRequest: prayer)
            }
        }
        .overlay {
            if prayerRequests.isEmpty {
                ContentUnavailableView {
                    Label("No Prayer Requests", systemImage: "list.bullet.rectangle.portrait")
                } description: {
                    Text("Start adding prayer requests to your list")
                } actions: {
                    Button(action: { addPrayerRequest() })
                    {
                        Text("Add Prayer Request")
                    }
                }
                .frame(height: 250)
                .offset(y: 120)
            }
        }
    }
    
    func addPrayerRequest() {
//        prayerRequestArray.append("TextString")
        //        let db = Firestore.firestore()
        //        let ref = db.collection("users").document("prayerRequests")
        
        //        ref.setData(["email": dataHolder.email, "prayStartDate": prayStartDate, "prayerList": prayerList])
    }
}

#Preview {
    PrayerRequestsView(prayerRequests:
                        [PrayerRequest(username: "matt", date: Date(), prayerRequestText: "Hello", status: "Current")]
    )
}

#Preview {
    PrayerRequestsView(prayerRequests:[] )
}
