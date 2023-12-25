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
                        self.register()
                    }) {Text("Create an Account")
                    }
                    .padding(.top, 10)
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
                userHolder.userID = Auth.auth().currentUser!.uid
                userHolder.isLoggedIn = true
                userHolder.person = PrayerPerson(name: "", username: email) // need to add Name retrieved from Firestore
                email = ""
                password = ""
                username = ""
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription.localizedLowercase)
            } else {
            }
        }
    }
    
//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if error != nil {
//                print(error!.localizedDescription.localizedLowercase)
//            } else {
//                var userID = result?.user.uid
//                let db = Firestore.firestore()
//                let ref = db.collection("users").document("\(userID)").collection("UserProfile").document()
//
//                ref.setData(["email: ": email, "username": username, "prayerList": prayerList])
//
//                saved = "Saved"
//                dismiss()
//            }
//        }
//    }
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
