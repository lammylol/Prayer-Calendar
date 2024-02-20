//
//  ProfileSettingsView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 2/9/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Settings page for user to edit profile information.
struct ProfileSettingsView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(PrayerListHolder.self) var prayerListHolder
    
    var body: some View {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            ProfilePictureAvatar(firstName: userHolder.person.firstName, lastName: userHolder.person.lastName, imageSize: 40, fontSize: 20)
                            Text(userHolder.person.firstName + " " + userHolder.person.lastName)
                        }
                        Spacer()
                    }
                }
                Section {
                    NavigationStack {
                        NavigationLink(destination: ProfileSettingsChangePasswordView()){
                            Text("Change Password")
                        }
                    }
                }
                Section{
                    Button(action: {
                        self.signOut()
                    }) {Text("Sign Out")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                }.frame(alignment: .center)
        }.navigationTitle("Settings")
    }
    
    func signOut() {
        // Sign out from firebase and change loggedIn to return to SignInView.
        try? Auth.auth().signOut()
        resetInfo()
    }

    func resetInfo() {
        userHolder.friendsList = []
        userHolder.isLoggedIn = false

        userHolder.person.userID = ""
        prayerListHolder.prayerList = ""
        prayerListHolder.prayStartDate = Date()
    }
}

enum PasswordChangeError: Error {
    case wrongCurrentPassword
    case invalidNewPasswordLength
}


struct ProfileSettingsChangePasswordView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var errorText = ""
    
    var body: some View {
        Form {
            Section(header: Text("Current Password")) {
                HStack{
                    Text("Current Password")
                    SecureField("", text: $currentPassword)
                }
            }
            Section(header: Text("New Password")) {
                HStack{
                    Text("New Password")
                    SecureField("", text: $newPassword)
                }
            }
            Section {
                Button(action: {
                    do {
                        try changePassword(currentPassword: currentPassword, newPassword: newPassword)
                        userHolder.userPassword = newPassword
                        errorText = "Password successfully changed."
                        print("Password successfully changed.")
                        currentPassword = ""
                        newPassword = ""
                    } catch PasswordChangeError.wrongCurrentPassword {
                        errorText = "Current password is incorrect. Please enter the correct password in order to change to your new password."
                    } catch PasswordChangeError.invalidNewPasswordLength {
                        errorText = "New password must be longer than 8 letters."
                    } catch {
                        print(error)
                    }
                }) {
                    Text("Change Password")
                        .foregroundStyle(.blue)
                }
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func changePassword(currentPassword: String, newPassword: String) throws -> Void {
        
        guard currentPassword == userHolder.userPassword else {
            throw PasswordChangeError.wrongCurrentPassword
        }
        
        guard newPassword.count > 8 else {
            throw PasswordChangeError.invalidNewPasswordLength
        }
        
        Auth.auth().currentUser?.updatePassword(to: newPassword)
    }
}

#Preview {
    ProfileSettingsView()
        .environment(UserProfileHolder.Blank())
}
//
//#Preview {
//    ProfileSettingsSignIn(userHolder: UserProfileHolder())
//        .environment(UserProfileHolder())
//}
