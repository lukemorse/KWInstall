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
            isLoggedIn ? AnyView(MainView()) : AnyView(LoginView { (success, teamName) in
                if success {
//                    self.mainViewModel.currentUser = username ?? ""
                    if let teamName = teamName {
                        self.mainViewModel.fetchTeamData(teamName: teamName)
                    }
                    self.isLoggedIn = true
                }
                else {
                    self.showingLoginAlert = true
                }
            })
        }
        .alert(isPresented: self.$showingLoginAlert) {
            Alert(title: Text("Incorrect username/password"))
        }
        
    }
    
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
