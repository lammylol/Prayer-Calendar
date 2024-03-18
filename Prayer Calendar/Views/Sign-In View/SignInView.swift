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
    @State var showForgotPassword: Bool = false
    @State var errorMessage = ""
    @State var text: String = ""
    @State var passwordText: String = ""
    
    var body: some View {
        if userHolder.isLoggedIn == false {
            NavigationView {
                VStack(/*spacing: 20*/) {
                    Spacer()
                    
                    Text("Welcome")
                        .font(.largeTitle)
                        .bold()
                        .offset(x: -80)
                    
                    VStack {
                        HStack {
                            Text("Email: ")
                                .padding(.leading, 40)
                            MyTextView(placeholder: "", text: $email, textPrompt: "enter email", textFieldType: "text")
                                .textContentType(.emailAddress)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .padding([.leading, .trailing], 40)
                        
                        HStack {
                            Text("Password: ")
                                .padding(.leading, 40)
                            MyTextView(placeholder: "", text: $password, textPrompt: "enter password", textFieldType: "secure")
                                .textContentType(.password)
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .padding([.leading, .trailing], 40)
                        
                        HStack {
                            Button(action: {
                                showForgotPassword.toggle()
                            }) {
                                Text("Forgot Password?")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 16))
                            }
                            Spacer()
                        }
                        .padding([.leading, .trailing], 40)
                        .padding(.top, 5)
                    }
                    
                    Button(action: {
                        Task {
                            signIn()
                        }
                    }) {Text("Sign In")
                            .bold()
                            .frame(height: 35)
                            .frame(maxWidth: .infinity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.blue)
                    )
                    .padding([.leading, .trailing], 40)
                    .foregroundStyle(.white)
                    .padding(.top, 30)
                    
                    if errorMessage != "" {
                        Text(errorMessage)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.red)
                            .padding([.leading, .trailing], 40)
                            .padding([.top, .bottom], 15)
                    }
                    
                    HStack {
                        Text("Don't have an account yet? ")
                        Button(action: {
                            showCreateAccount.toggle()
                        }) {
                            Text("Sign Up")
                        }
                    }
                    .padding([.top, .bottom], 15)
                    
                    Spacer()
                    
                }
                .sheet(isPresented: $showCreateAccount, onDismiss: {
                    errorMessage = ""
                }) {
                    CreateProfileView()
                }
                .sheet(isPresented: $showForgotPassword, onDismiss: {
                    errorMessage = ""
                }) {
                    ForgotPassword()
                }
            }.navigationViewStyle(.stack)
        }
        else {
            ContentView(selection: 1)
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let err = error as NSError
                if let authErrorCode = AuthErrorCode.Code(rawValue: err.code) {
                    
                    switch authErrorCode {
                    case .userNotFound:
                        errorMessage = "No account found with these credentials."
                    case .wrongPassword:
                        errorMessage = "Incorrect password entered. Please try again."
                    case .invalidEmail:
                        errorMessage = "Invalid email entered. Please enter a valid email."
                    case .networkError:
                        errorMessage = "A network error has occurred. Please try again later."
                    default:
                        errorMessage = "Invalid Credentials."
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
    
//    func signInWithGoogle() {
//        let provider = GoogleAuthProvider().responds(to: <#T##Selector!#>)
//        Google
//    }
    
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
            userHolder.pinnedPrayerRequests = try await PrayerFeedHelper().retrievePrayerRequestFeed(userID: userID, answeredFilter: "pinned")
            
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
                    .frame(maxWidth: .infinity)
                    .padding(.trailing, 40)
            }
        } else if textFieldType == "secure" {
            ZStack {
                SecureField(placeholder, text: $text, prompt: Text(textPrompt))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true) // for constraint issue
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                    .padding(.trailing, 40)
                    .background(
                        Rectangle().foregroundStyle(.clear)
                            .frame(height: 35)
                        )
            }
            
        }
    }
}

#Preview {
    SignInView()
        .environment(UserProfileHolder())
}
