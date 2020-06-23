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
    @State var installs: [Installation] = []
    @State var isLoading = false
    
    var body: some View {
        //        if let completedInstallations = mainViewModel.team?.completedInstallations {
        isLoading = true
        mainViewModel.fetchCompletedInstallations() { installs in
            self.installs = installs
            self.isLoading = false
        }
        
        if installs.count > 0 {
            return
                AnyView(List {
                    ForEach(installs, id: \.self) {install in
                        NavigationLink(destination: InstallationView(viewModel: InstallationViewModel(installation: install))) {
                            Text(install.schoolName)
                        }
                    }
                })
        }
        return AnyView(emptySection)
    }
    
    var emptySection: some View {
        Section {
            Text(isLoading ? "Loading..." : "No results")
                .foregroundColor(.gray)
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        return CompletedView().environmentObject(MainViewModel())
    }
}
