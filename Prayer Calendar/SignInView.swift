//
//  SignInView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/1/23.
//

import SwiftUI
import FirebaseAuth

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
                    
                    HStack {
                        Text("Email: ")
                        TextField("Enter Email", text: $email, prompt: Text("enter email"))
                            .frame(width: 250)
                    }
                        .offset(x: 0)
                    
                    Rectangle()
                        .frame(width: 310, height: 1)
                    
                    HStack {
                        Text("Password: ")
                        SecureField("Enter password", text: $password, prompt: Text("enter password"))
                            .frame(width: 250)
                    }
                        .offset(x: 15)
                    
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
                .frame(width: 350)
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
                self.loggedIn = false
            } else {
                self.loggedIn = true
                dataHolder.email = email
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in 
            if error != nil {
                print(error!.localizedDescription.localizedLowercase)
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
