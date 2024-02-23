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
        HStack {
            if profileOrPrayerFeed == "feed" {
                VStack() {
                    NavigationLink(destination: ProfileView(person: Person(userID: prayerRequest.userID, username: prayerRequest.username, firstName: prayerRequest.firstName, lastName: prayerRequest.lastName))) {
                        ProfilePictureAvatar(firstName: prayerRequest.firstName, lastName: prayerRequest.lastName, imageSize: 50, fontSize: 20)
                            .buttonStyle(.plain)
                            .foregroundStyle(Color.primary)
                    }
                    Spacer()
                }
                .padding(.trailing, 10)
            } else {
                VStack() {
                    ProfilePictureAvatar(firstName: prayerRequest.firstName, lastName: prayerRequest.lastName, imageSize: 50, fontSize: 20)
                        .buttonStyle(.plain)
                        .foregroundStyle(Color.primary)
                    Spacer()
                }
                .padding(.trailing, 10)
            }
            VStack(alignment: .leading) {
                HStack() {
                    Text(prayerRequest.firstName + " " + prayerRequest.lastName).font(.system(size: 16)).bold()
                    Spacer()
                    Text(prayerRequest.date, style: .date)
                }
                .font(.system(size: 12))
                .padding(.bottom, 2)
                Text("Prayer Status: ").font(.system(size: 12)).italic() + Text(prayerRequest.status.capitalized)
                    .font(.system(size: 12))
                    .italic()
                
                if prayerRequest.prayerRequestTitle != "" {
                    Text(prayerRequest.prayerRequestTitle)
                        .font(.system(size: 18))
                        .bold()
//                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
//                        .padding(.all, 7)
//                        .foregroundStyle(.white, .black)
//                        .background(
//                            RoundedRectangle(cornerRadius: 7)
//                                .fill(Color.random)
//                        )
                        .padding(.top, 7)
//                    Spacer()
                }
                
                if prayerRequest.latestUpdateText != "" {
                    VStack (alignment: .leading) {
                        Text("**\(prayerRequest.latestUpdateType)**: \(prayerRequest.latestUpdateDatePosted.formatted(date: .abbreviated, time: .omitted)), \(prayerRequest.latestUpdateText)")
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 16))
                            .italic()
                            .padding(.bottom, 0)
                        Text("\(prayerRequest.prayerRequestText)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .lineLimit(15)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 16))
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.top, 7)
                } else {
                    VStack {
                        Text(prayerRequest.prayerRequestText)
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .padding(.top, 7)
                    }
                }
            }
            .foregroundStyle(Color.primary)
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Divider()
    }
}

struct LatestUpdate: View {
    var prayerRequest: PrayerRequest
    
    var body: some View {
        VStack(alignment: .leading) {
//            HStack {
//                Text("Latest Update")
//                    .bold()
//                    .font(.system(size: 12))
//                Spacer()
//                Text("\(prayerRequest.latestUpdateDatePosted.formatted(date: .abbreviated, time: .omitted))")
//                    .font(.system(size: 12))
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(prayerRequest.latestUpdateType): \(prayerRequest.latestUpdateText)")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 14))
//            Spacer()
        }
//        .padding(.all, 10)
//        .foregroundStyle(.white, .black)
//        .background(
//            RoundedRectangle(cornerRadius: 7)
//                .fill(Color.random)
//        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension Color {
    static var random: Color {
        let colors = [
            Color
            .red,
            .green,
            .blue,
            .orange,
//            .yellow,
            .pink,
            .purple,
//            .gray,
            .black,
//            .primary,
            .secondary,
            .accentColor,
            .primary.opacity(0.75),
            .secondary.opacity(0.75),
            .accentColor.opacity(0.75)
        ]
        return colors.randomElement()!
    }
}

#Preview {
    PrayerRequestRow(prayerRequest: PrayerRequest(userID: "", username: "lammylol", date: Date(), prayerRequestText: "Prayers for this text to look beautiful. Prayers for this text to look beautiful.", status: "Current", firstName: "Matt", lastName: "Lam", priority: "high", prayerRequestTitle: "Prayers for Text", latestUpdateText: "Test Latest update: Prayers for this text to look beautiful. Prayers for this text to look beautiful.", latestUpdateDatePosted: Date(), latestUpdateType: "Testimony"), profileOrPrayerFeed: "feed").frame(maxHeight: 200)
}

#Preview {
    LatestUpdate(prayerRequest: PrayerRequest(userID: "", username: "lammylol", date: Date(), prayerRequestText: "Prayers for this text to look beautiful. Prayers for this text to look beautiful.", status: "Current", firstName: "Matt", lastName: "Lam", priority: "high", prayerRequestTitle: "Prayers for Text", latestUpdateText: "Test Latest update: Prayers for this text to look beautiful. Prayers for this text to look beautiful.", latestUpdateDatePosted: Date(), latestUpdateType: "Testimony"))
}
