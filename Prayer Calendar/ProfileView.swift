//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(DataHolder.self) var dataHolder
    @Environment(\.modelContext) var modelContext
    @Query var prayerRequests: [PrayerRequest]
    
    var body: some View {
//        dataHolder = dataHolder
        NavigationStack{
            ScrollView{
                VStack {
                    HStack () {
                        Text("You are logged in as:  \(dataHolder.email)").padding(.leading, 20)
//                        TextField("Enter Username", text: dataHolder.email, prompt: Text("enter username"))
//                            .frame(width: 150)
                        Spacer()
                    }
                    HStack () {
//                        Button(action: { submitUsername()}) {
//                            Text("Login")
//                        }
//                        .padding(.leading, 20)
//                        .buttonStyle(.bordered)
//                        Spacer()
                    }
                    Spacer()
                    Text("Prayer Requests")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    Divider()
                }
            }
                .navigationTitle("profile")
                .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
//    func submitUsername() {
//        dataHolder.username = username
//        print(dataHolder.username)
//    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(DataHolder())
    }
}
