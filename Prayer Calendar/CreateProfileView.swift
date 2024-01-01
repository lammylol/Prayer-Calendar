//
//  CreateProfileView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 12/3/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CreateProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var usernameCheck = ""
    
    var body: some View {
        NavigationView{
            VStack(/*spacing: 20*/) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .bold()
                    .offset(x: 0, y: 0)
                
                HStack {
                    Text("First Name: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $firstName, textPrompt: "first name", textFieldType: "text")
                }
                
                Rectangle()
                    .frame(width: 310, height: 1)
                
                HStack {
                    Text("Last Name: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $lastName, textPrompt: "last name", textFieldType: "text")
                }
                
                Rectangle()
                    .frame(width: 310, height: 1)
                
                HStack {
                    Text("Email: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $email, textPrompt: "enter email", textFieldType: "text")
//                        .keyboardType(.emailAddress)
                }
                
                Rectangle()
                    .frame(width: 310, height: 1)
                
                HStack {
                    Text("Username: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $username, textPrompt: "enter username", textFieldType: "text")
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
                    self.createAccount()
                }) {Text("Create Account")
                        .bold()
                        .frame(width: 150, height: 35)
                }
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.blue)
                )
                .foregroundStyle(.white)
                .padding(.top, 30)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func createAccount() {
        if PrayerPersonHelper().checkIfUsernameExists(username: username) == true {
            usernameCheck = "Username already taken. Please submit a new username."
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription.localizedLowercase)
                } else {
                    let userID = result?.user.uid
                    let db = Firestore.firestore()
                    let ref = db.collection("userinfo").document("\(userID ?? "")")/*.collection("UserProfile").document()*/
    
                    ref.setData(
                        ["email": email,
                         "username": username,
                         "firstName": firstName,
                         "lastName": lastName]
                    )
                    
                    let ref2 = db.collection("usernames").document("\(username)")/*.collection("\(userID ?? "")").document()*/
                    
                    ref2.setData(
                        ["username": username,
                         "userID": userID ?? "",
                         "firstName": firstName,
                         "lastName": lastName]
                    )
                    
                    print("Account successfully created.")
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateProfileView()
}
