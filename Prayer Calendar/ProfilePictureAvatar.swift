//
//  ProfilePictureAvatar.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/29/24.
//

import SwiftUI

struct ProfilePictureAvatar: View {
    let person: PrayerPerson
    let size: CGFloat

    var body: some View {
        HStack {
            let name = (person.firstName.first?.uppercased() ?? "") + (person.lastName.first?.uppercased() ?? "")
            ZStack {
                Circle()
//                    .stroke(Color.black, lineWidth: 4)
                    .frame(width: size, height: size)
                Text(name).foregroundStyle(.white).font(.system(size: 50))
            }
        }.shadow(radius: 10)
    }
}

#Preview {
    ProfilePictureAvatar(person: PrayerPerson(username: "", firstName: "Matt", lastName: "Lam"), size: 200)
}


