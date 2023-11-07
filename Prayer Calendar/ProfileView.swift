//
//  ProfileView.swift
//  PrayerCalendar
//
//  Created by Matt Lam on 10/6/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth

struct ProfileView: View {
    @Environment(DataHolder.self) var dataHolder
//    @Environment(\.modelContext) var modelContext
//    @Query var prayerRequests: [PrayerRequest]
    
    @State var username: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) { // LazyStack to freeze the top header when scrolling down.
                    Section {
                        VStack (spacing: 0) {
                            //To Fill in with Prayer Requests
                        }
                        .background(Color.gray.opacity(0.05))
                    } header: {
                        VStack {
                            Text("")
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        NavigationLink(destination: PrayerNameInputView(dataHolder: dataHolder)){
                                            Image(systemName: "list.bullet.rectangle")
                                        }
                                    }
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button(action: {
                                            self.signOut()
                                        }) {Text("sign out")
                                                .bold()
                                                .frame(width: 80, height: 25)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.black)
                                                )
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            Spacer()
                            HStack () {
                                Text("Logged in as: \(dataHolder.email)").padding(.leading, 20)
                                Spacer()
                            }
                            Spacer()
                            Text("Prayer Requests")
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    func signOut() {
        Auth.auth().signOut() { result, error in
            if error != nil {
                print("Error.")
            } else {
                SignInView()
            }
        }
    }
//        do {
//            try (
//                Auth.auth().signOut(),
//                SignInView()
//            )
//        } catch {
//            print("Error: cannot sign out.")
//        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(DataHolder())
    }
}
