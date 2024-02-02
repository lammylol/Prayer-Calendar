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
    let profileOrPrayerFeed: String
    
    var body: some View {
        VStack(){
            HStack() {
                if profileOrPrayerFeed == "feed" {
                    VStack() {
                        NavigationLink(destination: ProfileView(person: PrayerPerson(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName))){
                            ProfilePictureAvatar(firstName: prayerRequest.firstName, lastName: prayerRequest.lastName, imageSize: 50, fontSize: 20)
                        }.buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.trailing, 10)
                }
                if profileOrPrayerFeed == "feed" {
                    VStack(alignment: .leading) {
                        HStack() {
                            Text(prayerRequest.firstName + " " + prayerRequest.lastName).font(.system(size: 16)).bold()
                            Spacer()
                            Text(prayerRequest.date, style: .date)
                        }
                        .font(.system(size: 12))
                        .padding(.bottom, 2)
                        Text("Prayer Status: ").font(.system(size: 12))+Text(prayerRequest.status.capitalized).font(.system(size: 12))
                        Spacer()
                        Text("\(prayerRequest.prayerRequestText)").font(.system(size: 16))
                        Spacer()
                    }
                } else {
                    VStack(alignment: .leading) {
                        HStack() {
                            Text("status: ") + Text(prayerRequest.status.capitalized)
                            Spacer()
                            Text(prayerRequest.date, style: .date)
                        }.font(.system(size: 12))
                        
                        Spacer()
                        
                        Text("\(prayerRequest.prayerRequestText)")
                    }
                }
                //        .background(Color.gray.opacity(0.05))
            }
            Divider()
                .padding([.top, .bottom], 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing], 20)
    }
}

#Preview {
    PrayerRequestRow(prayerRequest: PrayerRequest(userID: "", username: "lammylol", date: Date(), prayerRequestText: "Prayers for this text to look beautiful. Prayers for this text to look beautiful.", status: "Current", firstName: "Matt", lastName: "Lam", priority: "high"), profileOrPrayerFeed: "feed").frame(maxHeight: 120)
}
