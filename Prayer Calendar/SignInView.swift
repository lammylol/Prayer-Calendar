//
//  SignInView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/1/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignInView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.colorScheme) var colorScheme
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var showCreateAccount: Bool = false
    
    var body: some View {
        Group {
            if userHolder.isLoggedIn == false {
                VStack(/*spacing: 20*/) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                        .offset(x: -80, y: -25)
                    
                    HStack {
                        Text("Email: ")
                            .padding(.leading, 40)
                        MyTextView(placeholder: "", text: $email, textPrompt: "enter email", textFieldType: "text")
//                            .keyboardType(.emailAddress)
                    }
                    
                    Rectangle()
                        .frame(width: 310, height: 1)
                    
                    HStack {
                        Text("Password: ")
                            .padding(.leading, 40)
                        MyTextView(placeholder: "", text: $password, textPrompt: "enter password", textFieldType: "secure")
                    }
                    
                    Rectangle()
                        .frame(width: 310, height: 1)
                
                    Button(action: {
                        self.signIn()
                    }) {Text("Login")
                            .bold()
                            .frame(width: 150, height: 35)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.blue)
                    )
                    .foregroundStyle(.white)
                    .padding(.top, 15)
                    
                    Button(action: {
                        showCreateAccount.toggle()
                    }) {Text("Create an Account")
                    }
                    .padding(.top, 10)
                }
                .sheet(isPresented: $showCreateAccount) {
                    CreateProfileView()
                }
            }
            else {
                ContentView()
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("no account found")
                userHolder.isLoggedIn = false
            } else {
                Task {
                    let userID = Auth.auth().currentUser!.uid
                    await PrayerPersonHelper().getUserInfo(userID: userID, email: email, userHolder: userHolder)
                    print("username: " + userHolder.person.username)
                    userHolder.isLoggedIn = true
                    email = ""
                    password = ""
                    username = ""
                }
            }
        }
    }
}

struct MyTextView: View {
    var placeholder: String = ""
    @Binding var text: String
    var textPrompt: String
    var textFieldType = ""
    
    var body: some View {
        if textFieldType == "text" {
            TextField(placeholder, text: $text, prompt: Text(textPrompt))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true) // for constraint issue
                .frame(minHeight: 35, maxHeight: 35)
                .padding(.trailing, 40)
        } else if textFieldType == "secure" {
            SecureField(placeholder, text: $text, prompt: Text(textPrompt))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true) // for constraint issue
                .frame(minHeight: 35, maxHeight: 35)
                .padding(.trailing, 40)
        }
    }
}

#Preview {
    SignInView()
        .environment(UserProfileHolder())
}
