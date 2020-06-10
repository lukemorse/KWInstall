//
//  CompletedView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        if let completedInstallations = mainViewModel.team?.completedInstallations {
        
        return AnyView(VStack {
            if completedInstallations.isEmpty {
                emptySection
            } else {
                List {
                    ForEach(completedInstallations.keys.sorted(), id: \.self) {key in
                        VStack {
                            self.getNavLink(schoolName: key, docID: completedInstallations[key] ?? "")
                        }
                        .padding()
                    }
                }
            }
            
            Spacer()
            })
        }
        return AnyView(emptySection)
    }
    
    func getNavLink(schoolName: String, docID: String) -> some View {
        return
            NavigationLink(destination: InstallationView(schoolName: schoolName, docID: docID))
         {
            Text(schoolName)
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        return CompletedView().environmentObject(MainViewModel())
    }
}
