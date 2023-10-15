//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import SwiftUI
import Observation

struct ProfileView: View {
    @Environment(DataHolder.self) var dataHolder
    @State var username: String = ""
    
    var body: some View {
//        Text("Hello World")
        @Bindable var dataHolder = dataHolder
        VStack {
            HStack () {
                Spacer()
                Text("Username: ")
                TextField("Enter Username", text: $username, prompt: Text("enter username"))
                    .frame(width: 150)
                Spacer()
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(DataHolder())
    }
}
