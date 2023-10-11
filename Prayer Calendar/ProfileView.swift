//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataHolder: DataHolder
    @State var username = ""
    
    var body: some View {
        VStack {
            Text("Hello World")
            HStack () {
                Spacer()
                Text("Username: ")
                TextField(text: $username, prompt: Text("enter username")) {
                }
            }
            Button(action: { submitUsername()}) {
                Text("Enter")
            }
        }
    }
    
    func submitUsername() {
        dataHolder.username = username
    }
    
}

#Preview {
    ProfileView(username: "Matt")
        .environmentObject(DataHolder())
}
