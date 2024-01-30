//
//  ProfilePictureAvatar.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 1/29/24.
//

import SwiftUI

struct ProfilePictureAvatar: View {
    let firstName: String
    let lastName: String
    let imageSize: CGFloat
    let fontSize: CGFloat

    var body: some View {
        HStack {
            let name = (firstName.first?.uppercased() ?? "") + (lastName.first?.uppercased() ?? "")
            ZStack {
                Circle()
//                    .stroke(Color.black, lineWidth: 4)
                    .frame(width: imageSize, height: imageSize)
                Text(name).foregroundStyle(.white).font(.system(size: fontSize))
            }
        }
//        .shadow(radius: 10)
    }
}

#Preview {
    ProfilePictureAvatar(firstName: "Matt", lastName: "Lam", imageSize: 200, fontSize: 20)
}


