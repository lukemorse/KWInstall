//
//  LoginView.swift
//  KW Install
//
//  Created by Luke Morse on 5/22/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginAlert = false
    
    var handler: (String, String, (Bool) -> Void) -> Void
    
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
    
    func attemptLogin() {
        handler(username,password) { success in
            print(success)
            if !success {
                showingLoginAlert = true
            }
        }
    }
    
    var logo: some View {
        Image("Launch Image")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 300)
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
            self.attemptLogin()
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
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView { (username, password, callBack: (Bool) -> Void) in
        }
    }
}
