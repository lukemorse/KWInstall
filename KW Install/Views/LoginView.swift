//
//  LoginView.swift
//  KW Install
//
//  Created by Luke Morse on 5/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import CodableFirebase

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginAlert = false
    
    init(logInHandler: @escaping (Bool, String?) -> ()) {
        self.viewModel = ViewModel(logInHandler: logInHandler)
    }
    
    var body: some View {
        VStack(spacing: 20.0) {
            logo
            usernameField
            passwordField
            logInButton
                
                .enableKeyboardOffset()
                .alert(isPresented: self.$showingLoginAlert) {
                    Alert(title: Text("Hello"))
            }
        }
        .padding()
    }
    
    var logo: some View {
        Image("Launch Image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300)
            .shadow(color: .blue, radius: 5, x: 20, y: 5)
    }
    
    var usernameField: some View {
        TextField("Enter username", text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textContentType(.oneTimeCode)
            .keyboardType(.emailAddress)
    }
    
    var passwordField: some View {
        SecureField("Enter password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numberPad)
    }
    
    var logInButton: some View {
        Button(action: {
            self.viewModel.attemptLogIn(username: self.username, password: self.password)
        }) {
            Text("Submit")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
    
    class ViewModel: ObservableObject {
        let logInHandler: (Bool, String?) -> Void
        @Published var loading = false
        
        init(logInHandler: @escaping (Bool, String?) -> Void) {
            self.logInHandler = logInHandler
        }
        
        func attemptLogIn(username: String, password: String) {
            loading = true
            let adjustedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            Firestore.firestore().collection(Constants.kLogInDataCollection).document(adjustedUsername).getDocument { (document, error) in
                if let error = error {
                    print(error)
                    self.logInHandler(false, nil)
                    self.loading = false
                } else {
                    do {
                        let doc = try FirestoreDecoder().decode([String:String].self, from: document!.data()!)
                        if doc["password"] == password {
                            self.loading = false
                            self.logInHandler(true, doc["teamName"] ?? "")
                        } else {
                            self.loading = false
                            self.logInHandler(false, nil)
                        }
                    } catch {
                        self.loading = false
                        print(error)
                    }
                }
            }
        }
    }
}


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView {}
//    }
//}
