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
    
    var body: some View {
        NavigationView{
            VStack(/*spacing: 20*/) {
                Text("Create an Account")
                    .font(.largeTitle)
                    .bold()
                    .offset(x: 0, y: -50)
                
                HStack {
                    Text("First Name: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $password, textPrompt: "first name", textFieldType: "text")
                }
                
                Rectangle()
                    .frame(width: 310, height: 1)
                
                HStack {
                    Text("Last Name: ")
                        .padding(.leading, 40)
                    MyTextView(placeholder: "", text: $password, textPrompt: "last name", textFieldType: "text")
                }
                
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
                    MyTextView(placeholder: "", text: $password, textPrompt: "enter password", textFieldType: "secure")
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
                    self.createAccount()
                }) {Text("Create an Account")
                }
                .padding(.top, 10)
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
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription.localizedLowercase)
                } else {
                    let userID = result?.user.uid
                    let db = Firestore.firestore()
                    let ref = db.collection("users").document("\(userID ?? "")").collection("UserProfile").document()
    
                    ref.setData(["email: ": email, "username": username, "firstName": firstName, "lastName": lastName])
                    
                    let ref2 = db.collection("users").document("\(username)")
                    ref2.setData(["userID": userID ?? ""])
//
//                    saved = "Saved"
                    dismiss()
                }
            }
    }
}

#Preview {
    CreateProfileView()
}
