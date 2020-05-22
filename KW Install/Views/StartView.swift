//
//  StartView.swift
//  KW Install
//
//  Created by Luke Morse on 4/10/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var isLoggedIn = false
    @State private var showingLoginAlert = false
    
    var body: some View {
        Group {
            isLoggedIn ? AnyView(MainView()) : AnyView(LoginView { (username, password, callBack: (Bool) -> Void) in
                var result = false
                let adjustedUsername = username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                
                if LogInData.data.keys.contains(adjustedUsername) {
                    if LogInData.data[adjustedUsername] == password {
                        result = true
                        if let teamDocID = LogInData.teamDocIdDict[adjustedUsername] {
                            self.mainViewModel.teamDocID = teamDocID
                        }
                    }
                }
                self.setLoggedIn(newVal: result)
                if !result {
                    self.showingLoginAlert = true
                }
            })
        }
        .alert(isPresented: self.$showingLoginAlert) {
            Alert(title: Text("Incorrect username/password"))
        }
        
    }
    
    private func setLoggedIn(newVal: Bool) {
        self.isLoggedIn = newVal
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
