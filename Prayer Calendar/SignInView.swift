//
//  SignInView.swift
//  Prayer Calendar
//
//  Created by Matt Lam on 11/1/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case networkError
    case invalidPassword
    case noUserFound
}

struct SignInView: View {
    @Environment(UserProfileHolder.self) var userHolder
    @Environment(\.colorScheme) var colorScheme
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var showCreateAccount: Bool = false
    @State var errorMessage = ""
    @State var text: String = ""
    @State var passwordText: String = ""
    
    var body: some View {
//        GeometryReader.init { geometry in
//                ScrollView.init {
//                    VStack.init(alignment: .leading, spacing: nil, content: {
//                        TextField("Hello", text: $text, prompt: Text("hello"))
//                            .frame(width: geometry.size.width, height: 50)
//                            .disableAutocorrection(true)
//                        
//                        SecureField("Hello", text: $passwordText, prompt: Text("hello"))
//                            .disableAutocorrection(true)
//                            .frame(width: geometry.size.width, height: 50)
//                    })
//                }
//        }
        
//        HStack {
//            Text("Email: ")
//                .padding(.leading, 40)
//            TextField("Hello", text: $text, prompt: Text("hello"))
//        }
//        HStack {
//            Text("Password: ")
//                .padding(.leading, 40)
//            SecureField("Hello", text: $passwordText, prompt: Text("hello"))
//        }
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
                            try signIn()
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
                    
                    Text(errorMessage)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.red)
                    
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
    
    func signIn() throws {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let err = error as NSError
                if let authErrorCode = AuthErrorCode.Code(rawValue: err.code) {
                    
                    switch authErrorCode {
                    case .userNotFound:
                        errorMessage = "User Not Found"
                    case .wrongPassword:
                        errorMessage = "Incorrect Password"
                    case .invalidEmail:
                        errorMessage = "Invalid Email"
                    case .networkError:
                        errorMessage = "Network Error"
                    default:
                        errorMessage = "Invalid Credentials"
                    }
                }
                print(errorMessage)
            } else {
                Task {
                    let userID = Auth.auth().currentUser!.uid
                    await getUserInfo(userID: userID, email: email)
                    userHolder.isLoggedIn = true
                    userHolder.userPassword = password
                    email = ""
                    password = ""
                    username = ""
                    errorMessage = ""
                }
            }
        }
    }
    
        //  This function retrieves Userinfo data from Firestore.
    func getUserInfo(userID: String, email: String) async {
        
        let db = Firestore.firestore()
//        let ref = db.collection("users").document(userID)
//        
        do {
            let ref = db.collection("users").document(userID)
            
            let document = try await ref.getDocument()
                    
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: " + dataDescription)
            
            let firstName = document.get("firstName") as! String
            let lastName = document.get("lastName") as! String
            let username = document.get("username") as! String
            let userID = document.get("userID") as! String
            
            let prayerPerson = Person(userID: userID, username: username, email: email, firstName: firstName, lastName: lastName)
            print("/username: " + prayerPerson.username)
            
            userHolder.person = prayerPerson
            print("//username: " + userHolder.person.username)
        } catch {
            print("Error retrieving user info.")
        }
                

        do {
            let friendsListRef = db.collection("users").document(userID).collection("friendsList")
            let querySnapshot = try await friendsListRef.getDocuments()

            //append FriendsListArray in userHolder
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
                userHolder.friendsList.append(document.documentID)
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
            ZStack {
                TextField(placeholder, text: $text, prompt: Text(textPrompt))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true) // for constraint issue
                    .frame(height: 35)
                    .padding(.trailing, 40)
                    .background(
                        Rectangle().foregroundStyle(.clear)
                            .frame(height: 35)
                        )
            }
        } else if textFieldType == "secure" {
            ZStack {
                SecureField(placeholder, text: $text, prompt: Text(textPrompt))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true) // for constraint issue
                    .frame(height: 35)
                    .padding(.trailing, 40)
                    .background(
                        Rectangle().foregroundStyle(.clear)
                            .frame(height: 35)
                        )
            }
            
        }
    }
}

//#Preview {
//    SignInView()
//        .environment(UserProfileHolder())
//}
