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
                        Task {
                            await signIn()
                        }
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
                ContentView(selection: 1)
            }
        }
    }
    
    func signIn() async {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("no account found")
                userHolder.isLoggedIn = false
            } else {
                Task {
                    let userID = Auth.auth().currentUser!.uid
                    await getUserInfo(userID: userID, email: email)
                    userHolder.isLoggedIn = true
                    email = ""
                    password = ""
                    username = ""
                }
//                print("//GETUSERINFO: username: " + userHolder.person.username + " userID: " + userHolder.person.userID)
//                print(userHolder.friendsList)
            }
        }
    }
    
        //  This function retrieves Userinfo data from Firestore.
    func getUserInfo(userID: String, email: String) async {
            
    //        userHolder.person.userID = userID
    //        userHolder.person.email = email
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userID)
        
        ref.getDocument{(document, error) in
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: " + dataDescription)
                
                let firstName = document.get("firstName") as! String
                let lastName = document.get("lastName") as! String
                let username = document.get("username") as! String
                let userID = document.get("userID") as! String
                
                let prayerPerson = PrayerPerson(userID: userID, username: username, email: email, firstName: firstName, lastName: lastName)
                print("/username: " + prayerPerson.username)
                
                userHolder.person = prayerPerson
                print("//username: " + userHolder.person.username)
            } else {
                print("Error retrieving user info. Some user info is passed as blank")
            }
        }
        do {
            let friendsListRef = db.collection("users").document(userID).collection("friendsList")
            let querySnapshot = try await friendsListRef.getDocuments()

            //append FriendsListArray in userHolder
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
                userHolder.friendsList.append(document.documentID)
//                if userHolder.friendsList
            }
        } catch {
          print("Error getting documents: \(error)")
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
