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
    @Environment(DataHolder.self) var dataHolder
    
    @State var loggedIn = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        Group {
            if loggedIn == false {
                VStack(spacing: 20) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                        .offset(x: -80, y: -20)
                    
                    TextField("Enter email", text: $email, prompt: Text("enter email"))
                        .frame(width: 310)
                    
                    Rectangle()
                        .frame(width: 310, height: 1)
                    
                    SecureField("Enter password", text: $password, prompt: Text("enter password"))
                        .frame(width: 310)
                    
                    Rectangle()
                        .frame(width: 310, height: 1)
                    
                    Button(action: {
                        self.signIn()
                    }) {Text("Login")
                            .bold()
                            .frame(width: 150, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.black)
                            )
                            .foregroundColor(.white)
                    }
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
        let db = Firestore.firestore()
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Error: No Account Found.")
                print("Please create new user or re-enter login details.")
                self.loggedIn = false
            } else {
                print("Success: Account Found.")
                print("You are now logged in as " + email)
                dataHolder.email = email
                self.loggedIn = true
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password)
        { result, error in
            if error != nil {
                print("Error: Account Already Exists.")
            } else {
            }
        }
//        let user = Auth.auth().currentUser;
//        if (user == nil) {
//            // there is no user signed in when user is nil
//            return false
//        } else { return true }
    }
}

#Preview {
    SignInView()
}
